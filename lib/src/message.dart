part of start_socket;

class Message {
  
  String _name;
  String get name => _name;
  
  var _data;
  get data => _data;
  
  Message(this._name, [this._data]);
  
  factory Message.fromPacket(String message) {
    if (message.isEmpty) {
      return new Message.empty();
    }
    
    List<String> parts = message.split(":");
    String name = parts.first;
    var data = null;
    if (parts.length > 1) {
      if (!parts[1].isEmpty) {
        data = Json.parse(parts.sublist(1).join(":"));
      }
    }
    return new Message(parts.first, data);
  }
  
  Message.empty() {
    this._name = "";
    this._data = null;
  }
  
  String toPacket() {
    return "$_name:${Json.stringify(_data)}";
  }
}