part of start_test;

class MockWebSocket extends Mock implements WebSocket {}

socket_tests() {
  group("Socket", () {
    MockWebSocket ws;
    Socket socket;
    
    setUp(() {
      ws = new MockWebSocket();
      socket = new Socket(ws);
    });
    
    test("can be constructed from a WebSocket", () {
      expect(socket.ws, equals(ws));
    });
    
    test("can send a message", () {
      String message = "Test";
      
      socket.send(message);
      
      ws.getLogs(callsTo("add", message)).verify(happenedOnce);
    });
  });
}