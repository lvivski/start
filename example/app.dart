import 'package:start/start.dart';
import 'views/views.dart';

import 'dart:io';

void main() {
  start(view: new View(), public: 'example/public', port: 3000).then((Server app) {
    app.get('/', (req, res) {
      res.render('index', {'title': 'Start'});
    });

    app.get('/hello/:name.:lastname?', (req, res) {
      res.header('Content-Type', 'text/html; charset=UTF-8')
      .send('Hello, ${req.param('name')} ${req.param('lastname')}');
    });

    app.ws('/socket', (socket) {
      socket.on('ping', () { socket.send('pong'); })
      .on('ping', () { socket.close(1, 'requested'); });
    });
    
    app.get('/file', (req, res) { // http://localhost:3000/file?name=example/public/stylesheets/main.css
      var file = new File(req.param('name')); 
      file.exists().then((found) {
        if (found) {
          file.readAsString().then((content) {
            res.send(content);
          });
        } else {
          res.status(404);
          res.close();
        }
      });
    });
  });
}