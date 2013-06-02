part of start;

class Message {
  
  String _name;
  String get name => _name;
  
  var _data;
  get data => _data;
  
  factory Message(String message) {
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
    return new Message._internal(parts.first, data);
  }
  
  Message._internal(this._name, this._data);
  
  Message.empty() {
    this._name = "";
    this._data = null;
  }
}