import 'dart:html';
import 'dart:json';

main() {
  var ws = new WebSocket("ws://127.0.0.1:3000/socket");

  ws.on.open.add((a) {
    ws.send("ping");
  });

  ws.on.close.add((c) {
    print('[${c.code}] ${c.reason}');
  });

  ws.on.message.add((m) {
    if (m.data == "pong") {
      print('got pong');
    }
  });
}