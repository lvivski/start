library socket_test;

import 'dart:io' hide Socket;

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

import 'package:start/start.dart';
import 'package:start/src/message.dart';

class MockWebSocket extends Mock implements WebSocket {}

void main() {
  group("Socket", () {
    MockWebSocket ws;
    Socket socket;

    setUp(() {
      ws = new MockWebSocket();
      socket = new Socket(ws);
    });

    test("can send a message", () {
      String message = "Test";

      socket.send(message);

      ws.getLogs(callsTo("add", message)).verify(happenedOnce);
    });

    test("can send a message with data", () {
      String msg_name = "Test";
      Map msg_data = {
        "name": "Bob",
        "age": 21,
        "awesome": true,
        "location": {
          "city": "Edmonton",
          "country": "Canada"
        },
        "favourite_things": [ 'kittens', 'puppies' ]
      };
      Message expected_msg = new Message(msg_name, msg_data);

      socket.send(msg_name, msg_data);

      ws.getLogs(callsTo("add", expected_msg.toPacket())).verify(happenedOnce);
    });
  });
}
