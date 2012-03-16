#import('unittest/unittest_dartest.dart');
#import('dartest/dartest.dart');

main() {
    group('Test Should', () {
        test('pass', () {
            Expect.equals(3, 1 + 2);
        });

        test('fail', () {
            Expect.equals(5, 2 + 2);
        });
    });
    new DARTest().run();
}


