import { Request } from "express";

type FlashMessageType = "info" | "error" | "success";

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
  readonly redirect: (url: string) => Response;
};

export interface Flash {
  setFlashMessage: (type: FlashMessageType, message: string) => number;
  setFlashMessages: (type: FlashMessageType, message: string[]) => number;
  flash: (type: FlashMessageType) => string[];
  flashAll: () => Record<FlashMessageType, string[]>;
}

declare global {
  namespace Express {
    export interface Request {
      Inertia: Inertia;
      flash: Flash;
    }
  }
}

declare module "express-session" {
  interface SessionData {
    flashMessages: Record<string, string[]>;
    xInertiaCurrentComponent: string | undefined;
    user: {
      id: string;
      owner: boolean;
      first_name: string;
      last_name: string;
    };
  }
}

export {};
