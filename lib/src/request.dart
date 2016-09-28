part of start;

class Request {
  final HttpRequest _request;
  Response response;

  Request(this._request);

  List header(String name) => _request.headers[name.toLowerCase()];

  bool accepts(String type) =>
      _request.headers[HttpHeaders.ACCEPT]
          .where((name) => name.split(',').indexOf(type))
          .length > 0;

  bool isMime(String type, {loose: false}) =>
      _request.headers[HttpHeaders.CONTENT_TYPE]
          .where((value) => loose ? value.contains(type) : value == type)
          .isNotEmpty;

  bool get isForwarded => _request.headers['x-forwarded-host'] != null;

  HttpRequest get input => _request;

  Map<String, String> get query => _request.uri.queryParameters;
  Map<String, String> params;

  List<Cookie> get cookies =>
      _request.cookies.map((Cookie cookie) {
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
    } else if (query[name] != null) {
      return query[name];
    }
    return null;
  }

  Future<Map> payload({ Encoding enc: UTF8 }) {
    var completer = new Completer();

    if (isMime('application/x-www-form-urlencoded')) {
      _request.transform(const AsciiDecoder())
          .listen((content) {
            final payload = new Map.fromIterable(
                content.split('&').map((kvs) => kvs.split('=')),
                key: (kv) => Uri.decodeQueryComponent(kv[0], encoding: enc),
                value: (kv) => Uri.decodeQueryComponent(kv[1], encoding: enc)
            );
            completer.complete(payload);
          });
    } else if (isMime('multipart/form-data', loose: true)) {
      var boundary = _request.headers.contentType.parameters['boundary'];
      final payload = new Map();
      _request.transform(new MimeMultipartTransformer(boundary))
          .map(HttpMultipartFormData.parse)
          .listen((HttpMultipartFormData formData) {
            var parameters = formData.contentDisposition.parameters;
            formData.listen((data) {
              if (formData.contentType != null) {
                data = new Upload(
                    parameters['filename'],
                    formData.contentType.mimeType,
                    formData.contentTransferEncoding.value,
                    data);
              }
              payload[parameters['name']] = data;
            });
          }, onDone: () {
            completer.complete(payload);
          });
    }
    return completer.future;
  }
}

class Upload {
  final String name;
  final String mime;
  final String enc;
  final data;
  const Upload(this.name, this.mime, this.enc, this.data);
}
