# Start
Sinatra inspired web framework.

[![](https://drone.io/lvivski/start/status.png)](https://drone.io/lvivski/start/latest)

It has simple API to serve static files from `public` folder (by default), rendered templates and websockets.

Start uses [Hart](https://github.com/lvivski/hart "lvivski/hart") as default template engine.

_**Note**: Current `dart` version doesn't support exporting of packages `bin` folder. So for now to use `start` you have to download the repository content and run your app from `example`. This behavior will be changed in future._

## Usage
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

## API

### start()
You start the server with `start()` function. It has 4 named arguments and returns `Server` future
```dart
start({view, String public: 'public', String host: '127.0.0.1', int port: 80})
```

The only required argument is `view`.

### Server
```dart
listen(host, port) // start the server (it's performed by the start function)
stop() // stops the server
get|post|put|delete(String route, handler(Request req, Response res))
// adds a handler
ws(String route, handler(Socket s)) // adds WebSocket handler
```

#### Routes
Route is a string with placeholders like `:name` its value is available through the Request `param()` method. Placeholders should start with colon `:`, if placeholder ends with a question mark `?` it's optional.
`"/hello/:name.:lastname?"` will match `"/hello/john"` and `"/hello/john.joe"`

### Request
```dart
header(String name) // get header
accepts(String type) // check accept header
input // raw HttpRequest stream
path // requested URI path
uri // requested URI
param(String name) // get query param by name
```

### Response
```dart
header(String name, [value]) // get or set header
get(String name) // get header
set(String name) // set header
type(contentType) // set Content-Type
cache(String cacheType) // set Cache-Control
status(code) // sets response status code
cookie(name, val) // sets cookie
add(string) // add a string to response
close() // closes response
send(string) // sends string and closes response
sendFile(path) // sends file content or 404 if not exists
json(Map data) // stringifies map and sends it
jsonp(String name, Map data) // stringifies map and sends it in callback as `name(data)`
render(viewName, [Map params]) // renders server view
```

### Socket
```dart
send(message) // sends message
on(message, action) // adds handler to message
close(status, reason) // closes socket
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
