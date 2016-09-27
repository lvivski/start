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

    if (this.isMime("application/x-www-form-urlencoded")) {
      _request.transform(const AsciiDecoder()).listen((content) {
        params = new Map.fromIterable(
            content.split('&').map((kvs) => kvs.split('=')),
            key: (kv) => Uri.decodeQueryComponent(kv[0], encoding: enc),
            value: (kv) => Uri.decodeQueryComponent(kv[1], encoding: enc)
          );
        completer.complete(params);
      });
    } else {
      Iterable<String> _contentTypes = _request.headers['content-type']
        .where((value) => value.startsWith("multipart/form-data"));
      if (_contentTypes.isNotEmpty) {
        // extract the boundary
        String boundaryBreak = "";
        // extract the boundary from the first instance of
        for (Match m in new RegExp(r'\"(.*?)\"').allMatches(_contentTypes.first))
          boundaryBreak = m.group(0)
          // Dart regex is weird, and is not properly taking out the quotes. for now this works..
          .substring(1, m.group(0).length - 1);
        String currentChunk = "";

        Map mapBuilder = {};
        _request
          .transform(const AsciiDecoder())
          .transform(const LineSplitter())
          .listen((String newContentLine)
        {

          // end of boundary? handle last chuck, and start next
          if (newContentLine.contains(boundaryBreak))
          {
            if(currentChunk.isNotEmpty)
            {
              // First line is the header, maybe not always true??

              // maybe parse the value based on the Content-Disposition?
              mapBuilder[
              // get the name from the name= to the new line.
              currentChunk.substring(currentChunk.indexOf("name=")+5, currentChunk.indexOf("\n"))
              ]
              // content starts at double new line
              = currentChunk.substring(currentChunk.indexOf("\n\n") + 2, currentChunk.lastIndexOf("\n"));

              // clear the chunk buffer, start next chunk
              currentChunk = "";
            }
          }
          else
            currentChunk += "$newContentLine\n";// Re-add the line breaks because the splitter removes them.

        }, onDone : () {
          completer.complete(mapBuilder);
        });

      }
    }
    return completer.future;
  }
}
