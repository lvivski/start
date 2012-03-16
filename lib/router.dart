#library('router');

#import('response.dart');
#import('request.dart');


class Router {
    List<Map> routes;

    parse (req, res) {
        var method = req.method;
        var path = req.path;
        var params = req.queryParameters;
        var headers = req.headers;
        var route = routes.filter((route) {
            return route['method'] == method.toUpperCase()
                && route['path'] == path;
        })[0];
        var action = route['action'];

        action(new Request(req), new Response(res));
    }

    add(String method, String path, Closure action) {
        if (['get','post','put','delete'].indexOf(method) < 0) {
            throw new Exception('no such method');
        }
        if (routes === null) {
            routes = [];
        }
        routes.add({
            'method': method.toUpperCase(),
            'path': path,
            'action': action
        });
    }
}

