import debug from "debug";
import { Response } from "express";
import { FastifyRequest } from "fastify";
import { FastifyReply } from "fastify";
import { FastifyPluginCallback } from "fastify";
const log = debug("inertia-node-adapter:fastify");
const fp = require('fastify-plugin')

type props = Record<string | number | symbol, unknown>;

export type Options = {
  readonly enableReload?: boolean;
  readonly version: string;
  readonly html: (page: Page, viewData: props) => string;
  readonly flashMessages?: (req: FastifyRequest, reply: FastifyReply) => props;
};

export type Page = {
  readonly component: string;
  props: props;
  readonly url: string;
  readonly version: string;
};
export type Inertia = {
  readonly setViewData: (viewData: props) => Inertia;
  readonly shareProps: (sharedProps: props) => Inertia;
  readonly setStatusCode: (statusCode: number) => Inertia;
  readonly setHeaders: (headers: Record<string, string>) => Inertia;
  readonly render: (Page: Page) => Promise<Response>;
  readonly redirect: (url: string) => FastifyReply;
};
export const headers = {
  xInertia: "x-inertia",
  xInertiaVersion: "x-inertia-version",
  xInertiaLocation: "x-inertia-location",
  xInertiaPartialData: "x-inertia-partial-data",
  xInertiaPartialComponent: "x-inertia-partial-component",
  xInertiaCurrentComponent: "x-inertia-current-component",
};
const inertiaFastifyPlugin: FastifyPluginCallback<Options> = (
  fastify,
  options,
  done
) => {
  let _viewData = {};
  let _sharedProps: props = {};
  let _statusCode = 200;
  let _headers: Record<string, string | string[] | undefined> = {};
  const { version, html, flashMessages, enableReload } = options;
  fastify.addHook("onRequest", (req, reply, next) => {
    const { sessionId } = req.session;
    if (
      req.method === "GET" &&
      req.headers[headers.xInertia] &&
      req.headers[headers.xInertiaVersion] !== version
    ) {
      req.sessionStore.destroy(sessionId, () => {
        reply.code(409).header(headers.xInertiaLocation, req.url).send();
      });
      return next();
    }

    const Inertia: Inertia = {
      setViewData(viewData) {
        _viewData = viewData;
        return this;
      },

      shareProps(sharedProps) {
        _sharedProps = { ..._sharedProps, ...sharedProps };
        return this;
      },

      setStatusCode(statusCode) {
        _statusCode = statusCode;
        return this;
      },

      setHeaders(headers) {
        _headers = { ...req.headers, ..._headers, ...headers };
        return this;
      },
      async render({ props, ...pageRest }) {
        const _page: Page = {
          ...pageRest,
          url: req.url,
          version,
          props,
        };
        log("rendering", _page);
        if (flashMessages) {
          log("Flashing messages");
          this.shareProps({ flash: flashMessages(req, reply) });
        }
        if (enableReload) {
          log("Setting session for reloading components");
          // @ts-ignore
          req.session.xInertiaCurrentComponent = pageRest.component;
        }
        const allProps = { ..._sharedProps, ...props };

        let dataKeys;
        const partialDataHeader = req.headers[headers.xInertiaPartialData];
        if (
          partialDataHeader &&
          req.headers[headers.xInertiaPartialComponent] === _page.component &&
          typeof partialDataHeader === "string"
        ) {
          dataKeys = partialDataHeader.split(",");
        } else {
          log(
            "partial requests without the name of the component return a full request",
            _page.component
          );
          log(
            "header partial component",
            req.headers[headers.xInertiaPartialComponent]
          );
          dataKeys = Object.keys(allProps);
        }

        // we need to clear the props object on each call
        const propsRecord: props = {};
        for await (const key of dataKeys) {
          log("parsing props keys", dataKeys);
          let value;
          if (typeof allProps[key] === "function") {
            value = await (allProps[key] as () => unknown)();
            log("prop promise resolved", key);
          } else {
            value = allProps[key];
          }
          propsRecord[key] = value;
        }
        _page.props = propsRecord;
        log("Page props built", _page.props);

        if (req.headers[headers.xInertia]) {
          log(`sent response with headers`);
          log(reply.getHeaders());

          return reply
            .status(_statusCode)
            .headers({
              ..._headers,
              "Content-Type": "application/json",
              [headers.xInertia]: "true",
              Vary: "Accept",
            })
            .send(JSON.stringify(_page));
        } else {
          log("Sending the default html as no inertia header is present");
          return reply
            .status(_statusCode)
            .headers({
              ...req.headers,
              ..._headers,
              "Content-Type": "text/html",
            })
            .send(html(_page, _viewData));
        }
      },

      redirect(url) {
        const statusCode = ["PUT", "PATCH", "DELETE"].includes(req.method)
          ? 303
          : 302;
        log(`Redirecting to ${req.method} ${url}`);
        return reply.redirect(statusCode, url);
      },
    };
    req.Inertia = Inertia;
    return next();
  });
  console.log("done")
  done();
};
export default fp(inertiaFastifyPlugin);
