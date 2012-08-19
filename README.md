# Start

Small server-side Dart web development framework.

It uses [Hart](https://github.com/lvivski/hart "lvivski/hart") as default template engine and can serve static files from `public` folder (by default).

``` dart
#library('app');

#import('lib/start.dart');
#import('lib/server.dart');

class App extends Server {
  App(): super() {
    get('/', (req, res) {
      res
        .render('index', {'title': 'Start'});
    });

    get('/hello/:name.:lastname?', (req, res) {
      res
        .header('Content-Type', 'text/html; charset=UTF-8')
        .send('Hello, ${req.param('name')} ${req.param('lastname')}');
    });
  }
}

void main() {
  start(new App(), '127.0.0.1', 3000);
}
```

## Instructions
- Download latest Dart SDK from http://www.dartlang.org/docs/getting-started/sdk/
- Checkout this repository and `cd` to its folder
- run
    ```
    $PATH_TO_DART_SDK/bin/dart /bin/run.dart
    ```
    This bin will install dependecies (hart), compile templates and start your application

- open http://127.0.0.1:3000/


## License

(The MIT License)

Copyright (c) 2012 Yehor Lvivski <lvivski@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
