library start_test;

import 'dart:json';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

import '../lib/src/message.dart';

part "message_test.dart";

main() {
  useHtmlConfiguration();

  message_tests();
}