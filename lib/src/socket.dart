part of start;

typedef void MsgHandler(data);

class Socket {
  WebSocket _ws;

  List<Map> _handlers;

  Socket(WebSocket ws) {
    this._ws = ws;
    _ws.listen((data) {
      Message msg = new Message(data);
      var handlers = _lookup(msg.name);
      if (handlers.length > 0) {
        handlers.forEach((handler) => handler['action'](msg.data));
      } else {
        // some err stuff
      }
    },
    onDone: () {
      print('[${_ws.closeCode}] ${_ws.closeReason}');
    });
  }

  void send(Object message) {
    _ws.add(message);
  }

  Socket on(Object message_name, MsgHandler action) {
    if (_handlers == null) {
      _handlers = [];
    }
    _handlers.add({
      'message_name': message_name,
      'action': action
    });
    return this;
  }

  void close([int status, String reason]) {
    _ws.close(status, reason);
  }

  List<Map> _lookup(String message_name) => _handlers.where((action) => action['message_name'] == message_name).toList();
}
