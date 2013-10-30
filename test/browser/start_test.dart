library start_test;

import 'dart:convert';
import 'dart:html';

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:unittest/html_config.dart';
import 'package:start/socket.dart';
import 'package:start/src/message.dart';

part '../message_test.dart';
part 'socket_test.dart';

main() {
  useHtmlConfiguration();

  message_tests();
  socket_tests();
}