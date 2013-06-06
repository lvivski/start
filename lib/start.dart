library start;

import 'dart:io' hide Socket, Cookie;
import 'dart:async';
import 'dart:json' as Json;
import 'src/cookie.dart';

part 'src/route.dart';
part 'src/request.dart';
part 'src/response.dart';
part 'src/message.dart';
part 'src/socket.dart';
part 'src/server.dart';
part 'src/mime_types.dart';

Future<Server> start({view, String public: 'public', String host: '127.0.0.1', int port: 80}) {
  return new Server(view, public).listen(host, port);
}
