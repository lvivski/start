import 'package:start/start.dart';
import 'package:logging/logging.dart';
import 'dart:convert';

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

    app.get('/file/:filename').listen((request) {
      request.response
          .header('Content-Type', 'text/html; charset=UTF-8')
          .send(request.param('filename'));
    });

    app.post('/upload').listen((request) {
      request.payload().then((payload) {
        var file = payload['file'] as Upload;
        request.response
            .header('Content-Type', 'text/html; charset=UTF-8')
            .add(payload['text'])
            .add('<br>')
            .add('<img src="data:${file.mime};base64,${BASE64.encode(file.data)}" />')
            .add('<br>')
            .add(file.name)
            .send('');
      });
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
