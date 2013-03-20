# Start

Sinatra inspired web framework.

[![](https://drone.io/lvivski/start/status.png)](https://drone.io/lvivski/start/latest)

It has simple API to serve static files from `public` folder (by default), rendered templates and websockets.

Start uses [Hart](https://github.com/lvivski/hart "lvivski/hart") as default template engine.

## Usase

Don't forget to compile views with `bin/compiler.dart` (views are precompiled in `example`).

```dart
import 'package:start/start.dart';
import 'views/views.dart';

void main() {
  start(view: new View(), public: 'example/public', port: 3000).then((app) {
    app.get('/', (req, res) {
      res.render('index', {'title': 'Start'});
    });

    app.get('/hello/:name.:lastname?', (req, res) {
      res.header('Content-Type', 'text/html; charset=UTF-8')
      .send('Hello, ${req.param('name')} ${req.param('lastname')}');
    });

    app.ws('/socket', (socket) {
      socket.on('ping', () { socket.send('pong'); })
      .on('ping', () { socket.close(1, 'requested'); });
    });
  });
}
```

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
