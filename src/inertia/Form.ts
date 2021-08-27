import * as Inertia from "@inertiajs/inertia";
import { RequestPayload } from "@inertiajs/inertia";

export default class Form<TForm extends Object> {
  private initialErrors: Record<keyof TForm, string>;
  private _transform: (data: TForm) => TForm = (data) => data;
  private isMounted = true;
  private recentlySuccessfulTimeoutId;
  private defaults: TForm;
  data: TForm;
  processing: boolean = false;
  isDirty: boolean;
  hasErrors: boolean;
  errors: Record<keyof TForm, string> = {} as Record<keyof TForm, string>;
  progress: number;
  wasSuccessful: boolean;
  recentlySuccessful: boolean;

  cancelToken: import("axios").CancelTokenSource;
  transform: (callback: (data: TForm) => TForm) => Form<TForm> = (callback) => {
    this._transform = callback;
    return this;
  };

  constructor(props: TForm) {
    this.defaults = { ...props };
    this.data = props;
    this.initialErrors = Object.keys(props).reduce(
      (acc, key) => ({ ...acc, [key]: "" }),
      {}
    ) as Record<keyof TForm, string>;
  }

  reset = (...fields: (keyof TForm)[]): void => {
    if (fields.length === 0) {
      this.data = { ...this.defaults };
    } else {
      this.data = Object.keys(this.defaults)
        .filter((key) => fields.includes(key as keyof TForm))
        .reduce(
          (carry, key) => {
            carry[key] = this.defaults[key];
            return carry;
          },
          { ...this.data }
        );
    }
    window.imba.commit();
  };
  clearErrors = (...fields: (keyof TForm)[]): void => {
    this.errors = Object.keys(this.errors).reduce(
      (carry, field) => ({
        ...carry,
        ...(fields.length > 0 && !fields.includes(field as keyof TForm)
          ? { [field]: this.errors[field] }
          : {}),
      }),
      {}
    ) as Record<keyof TForm, string>;

    this.hasErrors = Object.keys(this.errors).length > 0;
  };
  get = (url, options) => {
    this.submit("get", url, options);
  };
  post = (url, options) => {
    this.submit("post", url, options);
  };
  put = (url, options) => {
    this.submit("put", url, options);
  };
  patch = (url, options) => {
    this.submit("patch", url, options);
  };
  delete = (url, options) => {
    this.submit("delete", url, options);
  };
  cancel = () => {
    if (this.cancelToken) {
      this.cancelToken.cancel();
    }
    window.imba.commit();
  };

  submit = (
    method: "get" | "post" | "put" | "patch" | "delete",
    url,
    options: Inertia.VisitOptions = {}
  ) => {
    const _options = {
      ...options,
      onCancelToken: (token) => {
        this.cancelToken = token;

        if (options.onCancelToken) {
          return options.onCancelToken(token);
        }
      },
      onBefore: (visit) => {
        this.wasSuccessful = false;
        this.recentlySuccessful = false;
        clearTimeout(this.recentlySuccessfulTimeoutId);

        if (options.onBefore) {
          return options.onBefore(visit);
        }
      },
      onStart: (visit) => {
        this.processing = true;

        if (options.onStart) {
          return options.onStart(visit);
        }
      },
      onProgress: (event) => {
        this.progress = event;

        if (options.onProgress) {
          options.onProgress(event);
        }
        window.imba.commit();
      },
      onSuccess: (page) => {
        if (this.isMounted) {
          this.processing = false;
          this.progress = null;
          this.errors = { ...this.initialErrors };
          this.hasErrors = false;
          this.wasSuccessful = true;
          this.recentlySuccessful = true;
          this.recentlySuccessfulTimeoutId = setTimeout(() => {
            if (this.isMounted) {
              this.recentlySuccessful = false;
              window.imba.commit();
            }
          }, 2000);
        }

        if (options.onSuccess) {
          options.onSuccess(page);
        }
        window.imba.commit();
      },
      onError: (errors) => {
        if (this.isMounted) {
          this.processing = false;
          this.progress = null;
          this.errors = errors;
          this.hasErrors = true;
        }

        if (options.onError) {
          options.onError(errors);
        }
        window.imba.commit();
      },
      onCancel: () => {
        if (this.isMounted) {
          this.processing = false;
          this.progress = null;
        }

        if (options.onCancel) {
          options.onCancel();
        }
        window.imba.commit();
      },
      onFinish: () => {
        if (this.isMounted) {
          this.processing = false;
          this.progress = null;
        }

        this.cancelToken = null;

        if (options.onFinish) {
          // @ts-ignore
          options.onFinish();
        }
        window.imba.commit();
      },
    };

    if (method === "delete") {
      Inertia.Inertia.delete(url, {
        ..._options,
        // @ts-ignore
        data: this.transform(this.data),
      });
    } else {
      Inertia.Inertia[method](url, this._transform(this.data) as any, _options);
    }
  };
}
