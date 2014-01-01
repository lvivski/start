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

  Stream<Socket> ws(path) {
    var route = new Route.ws(path);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> get(path) {
    var route = new Route('get', path);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> options(path) {
    var route = new Route('options', path);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> post(path) {
    var route = new Route('post', path);
    _routes.add(route);

    return route.stream;
  }

  Stream<Request> put(path) {
    var route = new Route('put', path);
    _routes.add(route);

    return route.stream;
  }

  Stream delete(path) {
    var route = new Route('delete', path);
    _routes.add(route);

    return route.stream;
  }
}
