library server;

import 'dart:io' hide Socket;
import 'src/response.dart';
import 'src/request.dart';
import 'src/socket.dart';

class Server {
  HttpServer _server;
  String publicDir = 'public';
  var view;

  Server() : _server = new HttpServer();

  void stop() {
    _server.close();
  }

  void listen(host, port) {
    _server.defaultRequestHandler = (HttpRequest req, HttpResponse res) {
      new Response(res).sendFile(publicDir.concat(req.path));
    };
    _server.listen(host, port);
  }

  void noSuchMethod(InvocationMirror mirror) {
    var name = mirror.memberName,
        args = mirror.positionalArguments;

    if (['get','post','put','delete','ws'].indexOf(name) == -1) {
      throw new NoSuchMethodError(this, name, args, mirror.namedArguments);
    }

    Map route = {
      'method': name.toUpperCase(),
      'path': _normalize(args[0]),
      'action': args[1]
    };

    _server.addRequestHandler(
      _getMatcher(route),
      _getHandler(route)
    );
  }

  _getMatcher(Map route) {
    return (HttpRequest req) {
      String method = req.method;
      String path = req.path;
      return (route['method'] == method.toUpperCase() || route['method'] == 'WS')
          && route['path']['regexp'].hasMatch(path);
    };
  }

  _getHandler(Map route) {
    if (route['method'] == 'WS') {
      var ws = new WebSocketHandler();
      ws.onOpen = (WebSocketConnection conn) {
        var socket = new Socket(conn);
        route['action'](socket);
      };
      return ws.onRequest;
    } else {
      return (HttpRequest req, HttpResponse res) {
        var request = new Request(req);
        request.params = _parseParams(req.path, route['path']);
        route['action'](request, new Response(res, view));
      };
    }
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
        replace.add('\.');
      }
      replace.add('(\\w+))');
      if (placeholder[3] != null) {
        replace.add('?');
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
