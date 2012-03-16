#library('app');
#import('lib/start.dart');

void main() {
    var app = Start.createServer();

    app.get('/', (req, res) {
        res.send('Hello World');
    });

    app.listen(3000);
}
