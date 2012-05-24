#import('/Applications/Dart/dart-sdk/lib/unittest/unittest.dart');
#import('../lib/router.dart');

main() {
  group('Router first route', () {
    var router = new Router();
    router.add('get', '/', (){});
    var route = router.routes[0];

    test('method', () {
      expect(route['method']).equals('GET');
    });

    test('path', () {
      expect(route['path']['regexp'].pattern).equals('^/?\$');
    });

  });

  group('Route normalizer', () {
    var router = new Router();
    var route = router.normalize('/dfgdfg/:user/:name.:type?');
    test('placeholder (:)', () {
      expect(route['regexp'].pattern).equals('^/dfgdfg/(?:(\\w+))/(?:(\\w+))(?:.(\\w+))?/?\$');
      expect(route['keys'][0]).equals('user');
      expect(route['keys'][1]).equals('name');
    });

    test('params', () {
      var params = router.parseParams('/dfgdfg/candy/man/', route);
      expect(params['user']).equals('candy');
      expect(params['name']).equals('man');
    });
  });
}


