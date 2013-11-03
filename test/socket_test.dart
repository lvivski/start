part of start_test;

class MockWebSocket extends Mock implements WebSocket {}

io_socket_tests() {
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
