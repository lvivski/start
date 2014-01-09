part of start;

typedef void HttpHandler(Request req, Response r);
typedef void WsHandler(Socket s);

class Server {
  final String _public;
  final _routes = new List<Route>();
  HttpServer _server;

  Server(this._public);

  void stop() {
    _server.close();
  }

  Future<Server> listen(String host, num port) {
    return HttpServer.bind(host, port).then((HttpServer server){
      _server = server;
      _server.listen((HttpRequest req) {
        _routes.firstWhere((Route route) => route.match(req),
            orElse: () => new Route.file(_public))
            .handle(req);
      });

      return this;
    });
  }

  Stream<Socket> ws(path, { List<String> keys: null} ) {
    var route = new Route.ws(path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> get(path, { List<String> keys: null}) {
    var route = new Route('get', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> options(path, { List<String> keys: null}) {
    var route = new Route('options', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> post(path, { List<String> keys: null}) {
    var route = new Route('post', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> put(path, { List<String> keys: null}) {
    var route = new Route('put', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }

  Stream delete(path, { List<String> keys: null}) {
    var route = new Route('delete', path, keys: keys);
    _routes.add(route);

    return route.stream;
  }
}
