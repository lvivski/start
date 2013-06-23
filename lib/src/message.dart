library start_message;

import 'dart:json' as Json;

class Message {
  String name;
  var data;

  Message(this.name, [this.data]);

  factory Message.fromPacket(String message) {
    if (message.isEmpty) {
      return new Message.empty();
    }

    List<String> parts = message.split(':');
    String name = parts.first;
    var data = null;

    if (parts.length > 1 && !parts[1].isEmpty) {
      data = Json.parse(parts.sublist(1).join(':'));
    }

    return new Message(name, data);
  }

  Message.empty(): this('');

  String toPacket() {
    if (data == null) {
      return name;
    }
    return '$name:${Json.stringify(data)}';
  }
}