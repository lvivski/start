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

  /// Returns the value of the HTTP parameter with the given _name_.
  ///
  /// Returns the value of the named parameter from the query string or the
  /// request body, or an empty string if the it is not defined.
  ///
  /// If the parameter is defined in both, the value from the request body is returned.
  ///
  /// Note: when processing POST requests, the [payload] method should be
  /// called beforehand. Otherwise any parameters set in the request body
  /// are ignored.

  String param(String name) {
    var value;
    value = params[name];
    if (value != null) {
      return value;
    }
    value = _request.uri.queryParameters[name];
    if (value != null) {
      return value;
    }
    return ''; // no parameter with name found
  }

  /// Parses the request body for query parameters.
  ///
  /// Used for handling POST requests. This method must be used
  /// before [param] will return parameters from the request body,
  /// otherwise it only examines the query string.
  ///
  /// Returns the parameters parsed as a [Map] of names and values.

  Future<Map> payload({ Encoding enc: UTF8 }) {
    var completer = new Completer();
    _request.transform(const AsciiDecoder()).listen((content) {
      params = new Map.fromIterable(
          content.split('&').map((kvs) => kvs.split('=')),
          key: (kv) => Uri.decodeQueryComponent(kv[0], encoding: enc),
          value: (kv) => Uri.decodeQueryComponent(kv[1], encoding: enc)
      );
      completer.complete(params);
    });
    return completer.future;
  }
}
