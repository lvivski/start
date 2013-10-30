library start;

import 'dart:io' hide Socket;
import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';

import 'src/socket_base.dart';

part 'src/route.dart';
part 'src/request.dart';
part 'src/response.dart';
part 'src/server.dart';
part 'src/mime_types.dart';
part 'src/socket.dart';

Future<Server> start({ String public: 'web', String host: '127.0.0.1', int port: 80 }) {
  return new Server(public).listen(host, port);
}
