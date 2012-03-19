#library('request');

#import('dart:io');

class Request {
  HttpRequest request;
  Map params;

  Request (this.request);

  String header (String name) => request.headers[name.toLowerCase()];

  bool accepts (String type) => request.headers['accept'].split(',').indexOf(type) >= 0;

  bool isMime (String type) => request.headers['content-type'].contains(type);

  bool get isForwarded() => request.headers.containsKey('x-forwarded-host');

  get uri() => request.uri;

  param (String name) {
    if (params.containsKey(name)) {
      return params[name];
    }
    return request.queryParameters[name];
  }
}
