library server;

import 'dart:io' hide Socket;
import 'dart:async';
import 'src/response.dart';
import 'src/request.dart';
import 'src/socket.dart';

class Server {
  HttpServer _server;
  String _public;
  List<Map> _routes = [];
  var _view;

  Server(this._view, this._public);

  void stop() {
    _server.close();
  }

  Future listen(String host, num port) {
    defaultHandler(HttpRequest req) {
      new Response(req.response).sendFile(_public + req.uri.path);
    }
    
    return HttpServer.bind(host, port).then((HttpServer server){
      _server = server;
      _server.listen((HttpRequest req) {
        _routes.firstWhere(
            (route) => route['matcher'](req),
            orElse: () => { 'handler': defaultHandler })
            ['handler'](req);
      });
      
      return this;
    });
  }
  
  void ws(path, handler) {
    Map route = {
     'method': 'WS',
     'path': _normalize(path)
    };
    
    var controller = new StreamController();
    controller.stream.transform(new WebSocketTransformer()).listen((WebSocket ws){
      var socket = new Socket(ws);
      handler(socket);
    });
    
    _routes.add({
      'matcher': _getMatcher(route),
      'handler': (HttpRequest req) {
        controller.add(req);
      }
    });
    
  }

  void noSuchMethod(InvocationMirror mirror) {
    var name = mirror.memberName,
        args = mirror.positionalArguments;
    
    if (['get','post','put','delete'].indexOf(name) == -1) {
      throw new NoSuchMethodError(this, name, args, mirror.namedArguments);
    }

    Map route = {
      'method': name.toUpperCase(),
      'path': _normalize(args[0]),
      'action': args[1]
    };
    
    _routes.add({
      'matcher': _getMatcher(route),
      'handler': _getHandler(route)
    });
  }

  _getMatcher(Map route) {
    return (HttpRequest req) {
      String method = req.method;
      String path = req.uri.path;
      return (route['method'] == method.toUpperCase() || route['method'] == 'WS')
          && route['path']['regexp'].hasMatch(path);
    };
  }

  _getHandler(Map route) {
    return (HttpRequest req) {
      var request = new Request(req);
      request.params = _parseParams(req.uri.path, route['path']);
      route['action'](request, new Response(req.response, _view));
    };
  }

  Map _normalize(path, [bool strict = false]) {
    if (path is RegExp) {
      return {
        'regexp': path,
        'keys': []
      };
    }
    if (path is List) {
      path = '(${path.join('|')})';
    }
    path = path.concat(strict ? '' : '/?');

    List keys = [];

    RegExp placeholderRE = new RegExp(r'(\.)?:(\w+)(\?)?');
    Iterable<Match> matches = placeholderRE.allMatches(path);

    for (Match placeholder in matches) {
      StringBuffer replace = new StringBuffer('(?:');
      if (placeholder[1] != null) {
        replace.write('\.');
      }
      replace.write('(\\w+))');
      if (placeholder[3] != null) {
        replace.write('?');
      }
      path = path.replaceFirst(placeholder[0], replace.toString());
      keys.add(placeholder[2]);
    }

    path = path.replaceAll('//', '/');

    return {
      'regexp': new RegExp('^$path\$'),
      'keys': keys
    };
  }

  Map _parseParams(String path, Map routePath) {
    Map params = {};
    Match paramsMatch = routePath['regexp'].firstMatch(path);
    for (var i = 0; i < routePath['keys'].length; i++) {
      params[routePath['keys'][i]] = paramsMatch[i+1];
    }
    return params;
  }
}
