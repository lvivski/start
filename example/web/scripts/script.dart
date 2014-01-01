import 'package:start/socket.dart';

main() {
  var socket = new Socket('ws://127.0.0.1:3000/socket');

  socket.onOpen.listen((a) {
    print('client socket opened');
    socket.send('connected');
  });

  socket.onClose.listen((c) {
    print('client socket closed');
    print('[${c.code}] ${c.reason}');
  });

  socket.on('ping').listen((data) {
    print('ping: $data');
    socket.send('pong', 'data-from-pong');
  });
}
