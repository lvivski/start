part of start;

typedef void HttpHandler(Request req, Response r);
typedef void WsHandler(Socket s);

class Server {
  HttpServer _server;
  String _public;
  var _routes = new List<Route>(),
      _view;

  Server(this._view, this._public);

  void stop() {
    _server.close();
  }

  Future<Server> listen(String host, num port) {
    return HttpServer.bind(host, port).then((HttpServer server){
      _server = server;
      _server.listen((HttpRequest req) {
        _routes.firstWhere((Route route) => route.match(req),
            orElse: () => new Route.file(_public))
            .handle(req, _view);
      });

      return this;
    });
  }

  void ws(path, WsHandler handler) {
    _routes.add(new Route.ws(path, handler));
  } 

  void get(path, HttpHandler handler) {
    _routes.add(new Route('get', path, handler));
  }

  void post(path, HttpHandler handler) {
    _routes.add(new Route('post', path, handler));
  }

  void put(path, HttpHandler handler) {
    _routes.add(new Route('put', path, handler));
  }

  void delete(path, HttpHandler handler) {
    _routes.add(new Route('delete', path, handler));
  }
}
