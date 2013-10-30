library start_test;

import 'dart:convert';
import 'dart:io' hide Socket;

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

import 'package:start/start.dart';
import 'package:start/src/message.dart';

part 'message_test.dart';
part 'socket_test.dart';

main() {
  message_tests();
  io_socket_tests();
}