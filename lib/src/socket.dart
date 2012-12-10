library socket;

import 'dart:io' hide Socket;

class Socket {
  WebSocketConnection _conn;

  Map<Object,Function> _actions;

  Socket(conn) {
    this._conn = conn;

    _conn.onMessage = (Object message) {
      if (_actions[message] != null) {
        _actions[message]();
      } else {
        // some err stuff
      }
    };
    _conn.onClosed = (int status, String reason) {
      print('[$status] $reason');
    };
  }

  send(Object message) {
    _conn.send(message);
  }

  on(Object message, Function callback) {
    if (_actions == null) {
      _actions = {};
    }
    _actions[message] = callback;
    return this;
  }

  close([int status, String reason]) {
    _conn.close(status, reason);
  }
}
