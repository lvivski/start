library start_socket;

import 'dart:async';

import 'message.dart';

export 'message.dart' show Message;

abstract class SocketBase {
  void send(String msg_name, { data });

  Stream on(String message_name);

  void close([int status, String reason]);
}