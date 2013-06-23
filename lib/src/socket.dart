part of start;

class Socket {
  WebSocket _ws;

  var _messageController = new StreamController();
  Stream _messages = _messageController.stream;

  Socket(WebSocket ws) {
    this._ws = ws;
    _ws.listen((data) {
      var msg = new Message(data);
      _messageController.add(msg);
    },
    onDone: () {
      print('[${_ws.closeCode}] ${_ws.closeReason}');
    });
  }

  void send(Object message) {
    _ws.add(message);
  }

  Stream on(String messageName) {
    return _messages.where((msg) => msg.name == messageName);
  }

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }
}
