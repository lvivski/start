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
      var msg = new Message.fromPacket(e.data);
      _messageController.add(msg);
    });
  }

  void send(String messageName, [ data ]) {
    var message = new Message(messageName, data);
    _ws.send(message.toPacket());
  }

  Stream on(String messageName) {
    return _messages.where((msg) => msg.name == messageName).map((msg) => msg.data);
  }

  Stream get onOpen => _ws.onOpen;

  Stream get onClose => _ws.onClose;

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }
}