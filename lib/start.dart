#library('start');

#import('dart:io');
#import('router.dart');

class Start {
    HttpServer server;
    Router router;

    Start() {
        this.router = new Router();
        this.server = new HttpServer();
        this.server.onRequest = (HttpRequest req, HttpResponse res) {
            router.parse(req, res);
        };
    }

    static createServer() {
        return new Start();
    }

    listen (int portNumber) {
        server.listen('127.0.0.1', portNumber);
    }

    noSuchMethod (String name, List args) {
        router.add(name, args[0], args[1]);
    }
}
