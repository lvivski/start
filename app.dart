#library('app');
#import('lib/start.dart');

void main() {
  var app = Start.createServer();

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

  app.listen(3000);
}
