#library('app');
#import('lib/start.dart');

void main() {
  var app = new Start.createServer('127.0.0.1', 3000);

  app.get('/', (req, res) {
    res
      .header('Content-Type', 'text/html; charset=UTF-8')
      .send('Hello World');
  });


  app.get('/hello/:name.:lastname?', (req, res) {
    res
      .header('Content-Type', 'text/html; charset=UTF-8')
      .send('Hello, ' + req.param('name') + req.param('lastname'));
  });
}
