import 'package:start/start.dart';
import 'views/views.dart';

void main() {
  start(view: new View(), public: 'example/public', port: 3000).then((app) {
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
  });
}