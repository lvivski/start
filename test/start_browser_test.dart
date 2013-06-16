library start_test;

import 'dart:json';
import 'dart:html';

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:unittest/html_config.dart';
import 'package:start/socket.dart';

part "message_test.dart";
part "browser_socket_test.dart";

main() {
  useHtmlConfiguration();

  message_tests();
  socket_tests();
}