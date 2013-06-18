library start;

import 'dart:io' hide Socket;
import 'dart:async';
import 'dart:json' as Json;

part 'src/route.dart';
part 'src/request.dart';
part 'src/response.dart';
part 'src/message.dart';
part 'src/socket.dart';
part 'src/server.dart';
part 'src/mime_types.dart';

Future<Server> start({ String public: 'web', String host: '127.0.0.1', int port: 80 }) {
  return new Server(public).listen(host, port);
}
