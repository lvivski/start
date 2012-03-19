#import('unittest/unittest_dartest.dart');
#import('dartest/dartest.dart');
#import('../lib/router.dart');

main() {
  group('Router first route', () {
    var router = new Router();
    router.add('get', '/', (){});
    var route = router.routes[0];

    test('method', () {
      Expect.equals('GET', route['method']);
    });

    test('path', () {
      Expect.equals('^/?\$', route['path']['regexp'].pattern);
    });

  });

  group('Route normalizer', () {
    var router = new Router();
    var route = router.normalize('/dfgdfg/:user/:name.:type?');
    test('placeholder (:)', () {
      Expect.equals('^/dfgdfg/(?:(\\w+))/(?:(\\w+))(?:.(\\w+))?/?\$', route['regexp'].pattern);
      Expect.equals('user', route['keys'][0]);
      Expect.equals('name', route['keys'][1]);
    });

    test('params', () {
      var params = router.parseParams('/dfgdfg/candy/man/', route);
      Expect.equals('candy', params['user']);
      Expect.equals('man', params['name']);
    });
  });
  new DARTest().run();
}


