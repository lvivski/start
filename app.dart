#library('app');

#import('lib/start.dart');
#import('lib/server.dart');

class App extends Server {
  App(): super() {
    get('/', (req, res) {
      res
        .header('Content-Type', 'text/html; charset=UTF-8')
        .send('Hello World');
    });

    get('/hello/:name.:lastname?', (req, res) {
      res
        .header('Content-Type', 'text/html; charset=UTF-8')
        .send('Hello, ' + req.param('name') + req.param('lastname'));
    });
  }
}

void main() {
  start(new App(), '127.0.0.1', 3000);
}