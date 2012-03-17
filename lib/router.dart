#library('router');

#import('response.dart');
#import('request.dart');

class Router {
    List<Map> routes;

    parse (req, res) {
        var route = match(req);
        if (route == null) {
            new Response(res).status(404).send('Not found!');
            return;
        }
        var action = route['action'];
        Request request = new Request(req);
        request.setParams(parseParams(req.path, route['path']));
        action(request, new Response(res));
    }

    match (req) {
        String method = req.method;
        var path = req.path;
        var route = routes.filter((route) {
            var re = new RegExp(route['path']['regexp']);
            return route['method'] == method.toUpperCase()
                && re.hasMatch(path);
        });
        return route.length > 0 ? route[0] : null;
    }

    add (String method, String path, Closure action) {
        if (['get','post','put','delete'].indexOf(method) < 0) {
            throw new Exception('no such method');
        }
        if (routes == null) {
            routes = [];
        }
        routes.add({
            'method': method.toUpperCase(),
            'path': normalize(path),
            'action': action
        });
    }

    normalize (path, [bool strict = false]) {
        if (path is RegExp) {
            return path;
        }
        if (path is List) {
            path = '(' + Strings.join(path, '|') + ')';
        }
        path = path.concat(strict ? '' : '/?').replaceAll('//', '/');

        var keys = [];

        RegExp placeholderRE = const RegExp(@':(\w+)');
        placeholderRE.allMatches(path).forEach((placeholder) {
            keys.add(placeholder[1]);
        });

        path = '^' + path.replaceAll(placeholderRE, '(\\w+)') + '\$';

        return {
            'regexp':path,
            'keys':keys
        };
    }

    parseParams(String path, Map routePath) {
        Map params = {};
        Match match = new RegExp(routePath['regexp']).firstMatch(path);
        for (var i = 0; i < routePath['keys'].length; i++) {
            params[routePath['keys'][i]] = match[i+1];
        }
        return params;
    }
}

