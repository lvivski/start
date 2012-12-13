library socket;

import 'dart:io' hide Socket;

class Socket {
  WebSocketConnection _conn;

  List<Map> _handlers;

  Socket(WebSocketConnection conn) {
    this._conn = conn;

    _conn.onMessage = (Object message) {
      var handlers = _lookup(message);
      if (handlers.length > 0) {
        handlers.forEach((handler) => handler['action']());
      } else {
        // some err stuff
      }
    };
    _conn.onClosed = (int status, String reason) {
      print('[$status] $reason');
    };
  }

  void send(Object message) {
    _conn.send(message);
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
    _conn.close(status, reason);
  }

  List<Map> _lookup(Object message) => _handlers.filter((action) => action['message'] == message);
}
