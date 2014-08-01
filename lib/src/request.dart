part of start;

class Request {
  final HttpRequest _request;
  Response response;
  Map params;

  Request(this._request);

  List header(String name) => _request.headers[name.toLowerCase()];

  bool accepts(String type) =>
      _request.headers['accept'].where((name) => name.split(',').indexOf(type) ).length > 0;

  bool isMime(String type) =>
      _request.headers['content-type'].where((value) => value == type).isNotEmpty;

  bool get isForwarded => _request.headers['x-forwarded-host'] != null;

  HttpRequest get input => _request;

  List<Cookie> get cookies => _request.cookies.map((Cookie cookie) {
    cookie.name = Uri.decodeQueryComponent(cookie.name);
    cookie.value = Uri.decodeQueryComponent(cookie.value);
    return cookie;
  }).toList();

  String get path => _request.uri.path;

  Uri get uri => _request.uri;

  HttpSession get session => _request.session;

  String get method => _request.method;

  X509Certificate get certificate => _request.certificate;

  String param(String name) {
    if (params.containsKey(name) && params[name] != null) {
      return params[name];
    }
    return _request.uri.queryParameters[name] != null
         ? _request.uri.queryParameters[name]
         : '';
  }

  Future<Map> payload({ Encoding enc: UTF8 }) {
    var completer = new Completer();
    _request.transform(const AsciiDecoder()).listen((content) {
      final params = new Map.fromIterable(
          content.split('&').map((kvs) => kvs.split('=')),
          key: (kv) => Uri.decodeQueryComponent(kv[0], encoding: enc),
          value: (kv) => Uri.decodeQueryComponent(kv[1], encoding: enc)
      );
      completer.complete(params);
    });
    return completer.future;
  }
}
