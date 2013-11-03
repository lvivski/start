library start_socket;

import 'dart:async';

export 'message.dart' show Message;

abstract class SocketBase {
  void send(String msg_name, [ data ]);

  Stream on(String message_name);

  void close([int status, String reason]);
}
