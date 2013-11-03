import 'package:start/start.dart';

void main() {
  start(public: 'web', port: 3000).then((Server app) {

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
        socket.close(1000, 'requested');
      });
    });
  });
}
