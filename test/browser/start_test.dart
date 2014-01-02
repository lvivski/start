library start_test;

import 'package:unittest/html_config.dart';

import '../message_test.dart' as message;
import 'socket_test.dart' as socket;

void main() {
  useHtmlConfiguration();

  message.main();
  socket.main();
}
