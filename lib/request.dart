#library('request');

#import('dart:io');

class Request {
  HttpRequest request;
  Map params;

  Request(this.request);

  List header(String name) => request.headers[name.toLowerCase()];

  bool accepts(String type) =>
      request.headers['accept'].filter((name) => name.split(',').indexOf(type) ).length > 0;

  bool isMime(String type) =>
      request.headers['content-type'].map((value) => value == type).length > 0;

  bool get isForwarded() => request.headers['x-forwarded-host'] !== null;

  get uri() => request.uri;

  param(String name) {
    if (params.containsKey(name)) {
      return params[name];
    }
    return request.queryParameters[name];
  }
}
