import 'dart:html';
import 'dart:convert';

import 'package:start/socket.dart';

main() {
  var socket = new Socket('ws://127.0.0.1:3000/socket');

  socket.onOpen.listen((a) {
    socket.send('connected');
  });

  socket.onClose.listen((c) {
    print('[${c.code}] ${c.reason}');
  });

  socket.on('ping').listen((data) {
    socket.send('pong', 'data-from-pong');
  });
}
