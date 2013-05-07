part of start;

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

  void ws(path, action) {
    _routes.add(new Route.ws(path, action));
  }

  void get(dynamic path, Function action) {
    _routes.add(new Route('get', path, action));
  }

  void post(dynamic path, Function action) {
    _routes.add(new Route('post', path, action));
  }

  void put(dynamic path, Function action) {
    _routes.add(new Route('put', path, action));
  }

  void delete(dynamic path, Function action) {
    _routes.add(new Route('delete', path, action));
  }
}
