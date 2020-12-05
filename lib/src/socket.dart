part of start;

class Socket implements SocketBase {
  final WebSocket _ws;
  final _messageController = new StreamController(),
      _openController = new StreamController(),
      _closeController = new StreamController();

  Stream _messages;

  Socket(this._ws) {
    _messages = _messageController.stream.asBroadcastStream();

    _openController.add(_ws);
    _ws.listen((data) {
          _messageController.add(data);
        },
        onDone: () {
          _closeController.add(_ws);
        });
  }

  void send(String message) {
    _ws.add(message);
  }

  Stream onMessage() {
    return _messages;
  }

  Stream get onOpen => _openController.stream;

  Stream get onClose => _closeController.stream;

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }
}
