part of start;

class Socket implements SocketBase {
  WebSocket _ws;

  var _messageController = new StreamController();
  Stream _messages;

  Socket(this._ws) {
    _messages = _messageController.stream.asBroadcastStream();
    _ws.listen((data) {
      var msg = new Message.fromPacket(data);
      _messageController.add(msg);
    },
    onDone: () {
      print('[${_ws.closeCode}] ${_ws.closeReason}');
    });
  }

  void send(String messageName, [ data ]) {
    var message = new Message(messageName, data);
    _ws.add(message.toPacket());
  }

  Stream on(String messageName) {
    return _messages.where((msg) => msg.name == messageName).map((msg) => msg.data);
  }

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }
}
