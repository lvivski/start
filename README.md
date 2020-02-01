# Start

Sinatra inspired web framework.

[![](https://drone.io/lvivski/start/status.png)](https://drone.io/lvivski/start/latest)

It has simple API to serve static files, handle dynamic requests, websockets and create JSON responses.

```dart
import 'package:start/start.dart';

void main() {
  start(port: 3000).then((Server app) {

    app.static('web');

    app.get('/hello/:name.:lastname?').listen((request) {
      request.response
        .header('Content-Type', 'text/html; charset=UTF-8')
        .send('Hello, ${request.param('name')} ${request.param('lastname')}');
    });

    app.ws('/socket').listen((socket) {

      socket.onMessage().listen((data) {
        print('data: $data');
        socket.send(data);
      });

      socket.onOpen.listen((ws) {
        print('new socket opened');
      });

      socket.onClose.listen((ws) {
        print('socket has been closed');
      });

    });
}
```

## API

### start()

You start the server with `start()` function. It has 3 named arguments and
returns `Server` future

```dart
start({String host: '127.0.0.1', int port: 80})
```

### Server

```dart
listen(host, port) // start the server (it's performed by the start function)
stop() // stops the server
get|post|put|delete(String route) // adds a handler, returns a Stream<Request>
ws(String route) // adds WebSocket handler, returns a Stream
static(String path, {bool jail, bool listing, bool links}) // serves static files from `path`, follows symlinks outside the root if jail is false
```

#### Routes

Route is a string with placeholders like `:firstname` its value is
available through the Request `param()` method. Placeholders should start
with colon `:`, if placeholder ends with a question mark `?` it's optional.
`"/hello/:firstname.:lastname?"` will match `"/hello/john"` and
`"/hello/john.doe"`

### Request

```dart
header(String name) // get header
accepts(String type) // check accept header
input // raw HttpRequest stream
path // requested URI path
uri // requested URI
cookies // provided cookies
param(String name) // get query param by name
payload(Encoding enc) // get a promise with a Map of request body params
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
json(Map data) // stringifies map and sends it
jsonp(String name, Map data) // stringifies map and sends it in callback as `name(data)`
render(viewName, [Map params]) // renders server view
```

### Socket

```dart
send(message) // sends message
onMessage()   // adds handler to message
close(status, reason) // closes socket
```

## License

(The MIT License)

Copyright (c) 2012 Yehor Lvivski <lvivski@gmail.com>

Copyright (c) 2020 Benjamin Jung <bsjung@gmail.com>

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
