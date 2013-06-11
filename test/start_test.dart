library start_test;

import 'dart:json';
import 'dart:io' hide Socket;

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

import '../lib/start.dart';
import '../lib/socket.dart';

part 'message_test.dart';
part 'socket_test.dart';

main() {
  message_tests();
  socket_tests();
}