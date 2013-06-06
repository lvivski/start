import 'dart:html';
import 'dart:json';

main() {
  var ws = new WebSocket("ws://127.0.0.1:3000/socket");

  ws.onOpen.listen((a) {
    ws.send("ping");
  });

  ws.onClose.listen((c) {
    print('[${c.code}] ${c.reason}');
  });

  ws.onMessage.listen((m) {
    if (m.data == "pong") {
      print('got pong');
    }
  });
}