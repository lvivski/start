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
            Expect.equals('/', route['path']);
        });

    });
    new DARTest().run();
}


