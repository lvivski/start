library start;

import 'dart:async' show Future;

import 'server.dart';

Future<Server> start({view, String public: 'public', String host: '127.0.0.1', int port: 80}) {
  return new Server(view, public).listen(host, port);
}