import 'package:start/start.dart';

import 'package:http_server/http_server.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  start(port: 3000).then((Server app) {

    app.static('web', jail: false);

    app.get('/hello/:name.:lastname?').listen((request) {
      request.response
        .header('Content-Type', 'text/html; charset=UTF-8')
        .send('Hello, ${request.param('name')} ${request.param('lastname')}');
    });

    app.ws('/socket').listen((socket) {
      socket.on('connected').listen((data) {
        socket.send('ping', 'data-from-ping');
      });

      socket.on('pong').listen((data) {
        print('pong: $data');
        socket.close(1000, 'requested');
      });

      socket.onOpen.listen((ws) {
        print('new socket opened');
      });

      socket.onClose.listen((ws) {
        print('socket has been closed');
      });
    });
  });
}
