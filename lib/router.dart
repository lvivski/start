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
    request.params = parseParams(req.path, route['path']);
    action(request, new Response(res));
  }

  match (req) {
    String method = req.method;
    var path = req.path;
    var route = routes.filter((route) {
      return route['method'] == method.toUpperCase()
        && route['path']['regexp'].hasMatch(path);
    });
    return route.length > 0 ? route[0] : null;
  }

  void add (String method, String path, Function action) {
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

  Map normalize (path, [bool strict = false]) {
    if (path is RegExp) {
      return path;
    }
    if (path is List) {
      path = '(' + Strings.join(path, '|') + ')';
    }
    path = path.concat(strict ? '' : '/?');

    var keys = [];

    RegExp placeholderRE = const RegExp(@'(\.)?:(\w+)(\?)?');
    placeholderRE.allMatches(path).forEach((placeholder) {
      String replace = '(?:';
      if (placeholder[1].length > 0) {
        replace += '\.';
      }
      replace += '(\\w+))';
      if (placeholder[3].length > 0) {
        replace += '?';
      }
      path = path.replaceFirst(placeholder[0], replace);
      keys.add(placeholder[2]);
    });

    path = path.replaceAll('//', '/');

    return {
      'regexp': new RegExp('^' + path + '\$'),
      'keys':keys
    };
  }

  Map parseParams(String path, Map routePath) {
    Map params = {};
    Match paramsMatch = routePath['regexp'].firstMatch(path);
    for (var i = 0; i < routePath['keys'].length; i++) {
      params[routePath['keys'][i]] = paramsMatch[i+1];
    }
    return params;
  }
}

