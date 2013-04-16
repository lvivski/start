library server;

import 'dart:io';
import 'dart:async';
import 'src/route.dart';

class Server {
  HttpServer _server;
  String _public;
  var _routes = new List<Route>(),
      _view;

  Server(this._view, this._public);

  void stop() {
    _server.close();
  }

  Future listen(String host, num port) {
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

  void noSuchMethod(InvocationMirror mirror) {
    var method = mirror.memberName,
        args = mirror.positionalArguments;
    
    if (['get','post','put','delete'].indexOf(method) == -1) {
      throw new NoSuchMethodError(this, method, args, mirror.namedArguments);
    }
    
    _routes.add(new Route(method, args[0], args[1]));
  }
}
