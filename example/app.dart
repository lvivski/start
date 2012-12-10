library app;

import 'package:start/start.dart';
import 'package:start/server.dart';

import 'views/views.dart';

class App extends Server {
  App(): super() {
    view = new View();
    publicDir = 'example/public';

    get('/', (req, res) {
      res.render('index', {'title': 'Start'});
    });

    get('/hello/:name.:lastname?', (req, res) {
      res.header('Content-Type', 'text/html; charset=UTF-8')
         .send('Hello, ${req.param('name')} ${req.param('lastname')}');
    });

    ws('/socket', (socket) {
      socket.on('ping', () { socket.send('pong'); })
            .on('terminate', () { socket.close(1, 'requested'); });
    });
  }
}

void main() {
  start(new App(), '127.0.0.1', 3000);
}