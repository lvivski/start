library route;

import 'dart:io' hide Socket;
import 'dart:async';

import 'request.dart';
import 'response.dart';
import 'socket.dart';

typedef bool Matcher(HttpRequest req);
typedef void Handler(HttpRequest req, [view]);

class Route {
  Matcher matcher;
  Handler handler;
  
  Route(String method, path, action) {
    path = _normalize(path);
    this.matcher = _getMatcher(method, path);
    this.handler = _getHandler(path, action);
  }
  
  Route.file(String dir) {
    this.handler = (HttpRequest req, [view]) {
      new Response(req.response).sendFile(dir + req.uri.path);
    }; 
  }
  
  Route.ws(path, action) {
    var controller = new StreamController();
    controller.stream.transform(new WebSocketTransformer()).listen((WebSocket ws){
      var socket = new Socket(ws);
      action(socket);
    });
    
    this.matcher = _getMatcher('ws', _normalize(path));
    
    this.handler = (HttpRequest req, [view]) {
      controller.add(req);
    };
  }
    
  _getMatcher(String method, Map path) {
    return (HttpRequest req) {
      return (method.toLowerCase() == req.method.toLowerCase())
          && path['regexp'].hasMatch(req.uri.path);
    };
  }
  
  _getHandler(path, action) {
    return (HttpRequest req, [view]) {
      var request = new Request(req);
      request.params = _parseParams(req.uri.path, path);
      action(request, new Response(req.response, view));
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