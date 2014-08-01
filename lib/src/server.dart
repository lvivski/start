part of start;

typedef void HttpHandler(Request req, Response r);
typedef void WsHandler(Socket s);

class Server {
  final Logger log = new Logger('start.server');
  final List<Route> _routes = new List<Route>();
  HttpServer _server;
  VirtualDirectory _staticServer;

  Server();

  void stop() {
    _server.close();
  }

  Future<Server> listen(String host, num port) {
    return HttpServer.bind(host, port).then((HttpServer server){
      _server = server;
      _server.listen((HttpRequest req) {
        var route = _routes.firstWhere((Route route) => route.match(req), orElse: () => null);
        if (route != null) {
          route.handle(req);
        } else if (_staticServer != null) {
          _staticServer.serveRequest(req);
        } else {
          _send404(req);
        }
      });

      log.fine('Server started, listening on $host:$port');

      return this;
    });
  }

  void static(path, { listing: true, links: true, jail: true }) {
    _staticServer = new VirtualDirectory(path)
      ..allowDirectoryListing = listing
      ..followLinks = links
      ..jailRoot = jail
      ..errorPageHandler = _send404;

    _staticServer.directoryHandler = (Directory dir, HttpRequest req) {
      var filePath = '${dir.path}${Platform.pathSeparator}index.html';
      var file = new File(filePath);
      _staticServer.serveFile(file, req);
    };
  }

  Stream<Socket> ws(path, { List<String> keys } ) {
    var route = new Route.ws(path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> get(path, { List<String> keys }) {
    var route = new Route('get', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> options(path, { List<String> keys }) {
    var route = new Route('options', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> post(path, { List<String> keys }) {
    var route = new Route('post', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> put(path, { List<String> keys }) {
    var route = new Route('put', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream delete(path, { List<String> keys }) {
    var route = new Route('delete', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  void _send404(HttpRequest req) {
    req.response
      ..statusCode = HttpStatus.NOT_FOUND
      ..close();
  }
}
