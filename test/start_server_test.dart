library start_test;

import 'dart:json';
import 'dart:io' hide Socket;

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

import 'package:start/start.dart';

part 'message_test.dart';
part 'vm_socket_test.dart';

main() {
  message_tests();
  io_socket_tests();
}