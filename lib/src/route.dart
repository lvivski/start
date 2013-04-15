library route;

import 'dart:io' hide Socket;
import 'dart:async';

import 'request.dart';
import 'response.dart';
import 'socket.dart';

class Route {
  String _method;
  Map _path;
  Function _action;
  String _dir;
  StreamController _controller;
  
  Route(this._method, path, this._action) {
    this._path = _normalize(path);
  }
  
  Route.file(this._dir); 
  
  Route.ws(path, action) {
    this._method = 'ws';
    this._path = _normalize(path);
    _controller = new StreamController();
    _controller.stream.transform(new WebSocketTransformer()).listen((WebSocket ws){
      var socket = new Socket(ws);
      action(socket);
    });
  }
  
  match(HttpRequest req) {
    return ((_method.toLowerCase() == req.method.toLowerCase())
        && _path['regexp'].hasMatch(req.uri.path));
  }
  
  handle(HttpRequest req, [view]) {
    if (_dir != null) {
      new Response(req.response).sendFile(_dir + req.uri.path);
    } else if (_controller != null) {
      _controller.add(req);
    } else {
      var request = new Request(req);
      request.params = _parseParams(req.uri.path, _path);
      _action(request, new Response(req.response, view));
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