part of start_test;

message_tests() {
  group("Message,", () {
    test("parses empty message", () {
      Message msg = new Message("");
      
      expect(msg.name, equals(""));
      expect(msg.data, equals(null));
    });
    
    test("parses named message", () {
      Message msg = new Message("test");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(null));
    });
    
    test("parses named message with empty data", () {
      Message msg = new Message("test:");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(null));
    });
    
    test("parses named message with Map for data", () {
      Map data = {
        "stuff":123,
        "other":"test"
      };
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses named message with List for data", () {
      List data = [1, 2, 3];
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses named message with bool for data", () {
      bool data = true;
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses named message with String for data", () {
      String data = "abc123";
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses named message with String containing colon for data", () {
      String data = "a:b:c";
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses named message with int for data", () {
      int data = 123;
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses named message with double for data", () {
      double data = 123.45;
      Message msg = new Message("test:${stringify(data)}");
      
      expect(msg.name, equals("test"));
      expect(msg.data, equals(data));
    });
    
    test("parses unnamed message with Map for data", () {
      Map data = {
        "stuff":123,
        "other":"test"
      };
      Message msg = new Message(":${stringify(data)}");
      
      expect(msg.name, equals(""));
      expect(msg.data, equals(data));
    });
  });
}