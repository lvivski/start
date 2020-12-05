library start.socket;

import 'dart:html';
import 'dart:async';

import 'src/socket_base.dart';

class Socket implements SocketBase {
  final _messageController = new StreamController();
  final WebSocket _ws;
  Stream _messages;

  Socket(String url) :
        this._ws = new WebSocket(url) {
    _messages = _messageController.stream.asBroadcastStream();
    _ws.onMessage.listen((e) {
      var msg = e.data;
      _messageController.add(msg);
    });
  }

  void send(String message) {
    _ws.send(message);
  }

  Stream onMessage() {
    return _messages;
  }

  Stream get onOpen => _ws.onOpen;

  Stream get onClose => _ws.onClose;

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }
}
