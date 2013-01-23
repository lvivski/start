library request;

import 'dart:io';

class Request {
  HttpRequest _request;
  Map params;

  Request(this._request);

  List header(String name) => _request.headers[name.toLowerCase()];

  bool accepts(String type) =>
      _request.headers['accept'].where((name) => name.split(',').indexOf(type) ).length > 0;

  bool isMime(String type) =>
      _request.headers['content-type'].where((value) => value == type).length > 0;

  bool get isForwarded => _request.headers['x-forwarded-host'] != null;

  InputStream get input => _request.inputStream;

  String get path => _request.path;

  get uri => _request.uri;

  param(String name) {
    if (params.containsKey(name) && params[name] != null) {
      return params[name];
    }
    return _request.queryParameters[name] != null
         ? _request.queryParameters[name]
         : '';
  }
}
