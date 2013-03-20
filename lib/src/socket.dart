library socket;

import 'dart:io' hide Socket;
import 'dart:async';

class Socket {
  WebSocket _ws;

  List<Map> _handlers;

  Socket(WebSocket ws) {
    this._ws = ws;
    _ws.listen((message) {
      var handlers = _lookup(message);
      if (handlers.length > 0) {
        handlers.forEach((handler) => handler['action']());
      } else {
        // some err stuff
      }
    },
    onDone: () {
      print('[${_ws.closeCode}] ${_ws.closeReason}');
    });
  }

  void send(Object message) {
    _ws.send(message);
  }

  Socket on(Object message, Function action) {
    if (_handlers == null) {
      _handlers = [];
    }
    _handlers.add({
      'message': message,
      'action': action
    });
    return this;
  }

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }

  List<Map> _lookup(Object message) => _handlers.where((action) => action['message'] == message).toList();
}
