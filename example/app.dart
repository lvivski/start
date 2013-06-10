import 'package:start/start.dart';
import 'views/views.dart';

import 'dart:io';

void main() {
  start(view: new View(), public: 'web', port: 3000).then((Server app) {

    app.get('/').listen((request) {
      request.response.render('index', {'title': 'Start'});
    });

    app.get('/hello/:name.:lastname?').listen((request) {
      request.response
        .header('Content-Type', 'text/html; charset=UTF-8')
        .send('Hello, ${request.param('name')} ${request.param('lastname')}');
    });

    app.ws('/socket').listen((socket) {
      socket.on('ping', (data) { socket.send('pong'); })
        .on('pong', (data) { socket.close(1000, 'requested'); });
    });

    app.get('/file').listen((request) { // http://localhost:3000/file?name=web/stylesheets/main.css
      var file = new File(request.param('name'));
      file.exists().then((found) {
        if (found) {
          file.readAsString().then((content) {
            request.response.send(content);
          });
        } else {
          request.response.status(404);
          request.response.close();
        }
      });
    });
  });
}