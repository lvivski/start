part of start;

class Socket implements SocketBase {
  final WebSocket _ws;
  final _messageController = new StreamController(),
        _openController = new StreamController(),
        _closeController = new StreamController();

  Stream _messages;

  Socket(this._ws) {
    // TODO remove this broadcast stream
    _messages = _messageController.stream.asBroadcastStream();

    _openController.add(_ws);
    _ws.listen((data) {
      var msg = new Message.fromPacket(data);
      _messageController.add(msg);
    },
    onDone: () {
      _closeController.add(_ws);
    });
  }

  void send(String messageName, [ data ]) {
    var message = new Message(messageName, data);
    _ws.add(message.toPacket());
  }

  Stream on(String messageName) {
    return _messages.where((msg) => msg.name == messageName).map((msg) => msg.data);
  }

  Stream get onOpen => _openController.stream;

  Stream get onClose => _closeController.stream;

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }
}
