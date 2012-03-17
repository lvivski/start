#library('app');
#import('lib/start.dart');

void main() {
    var app = Start.createServer();

    app.get('/', (req, res) {
        res
            .header('Content-Type', 'text/html; charset=UTF-8')
            .send('Hello World');
    });


    app.get('/hello/:name', (req, res) {
        res
            .header('Content-Type', 'text/html; charset=UTF-8')
            .send('Hello, ' + req.param('name'));
    });


    app.listen(3000);
}
