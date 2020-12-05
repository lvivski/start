library start_socket;

import 'dart:async';

abstract class SocketBase {
  void send(String msg);

  Stream onMessage();

  void close([int status, String reason]);
}
