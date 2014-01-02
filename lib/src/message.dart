library start_message;

import 'dart:convert';

class Message {
  final String name;
  final Object data;

  Message(this.name, [this.data]);

  factory Message.fromPacket(String message) {
    if (message.isEmpty) {
      return new Message.empty();
    }

    List<String> parts = message.split(':');
    String name = parts.first;
    var data = null;

    if (parts.length > 1 && !parts[1].isEmpty) {
      data = JSON.decode(parts.sublist(1).join(':'));
    }

    return new Message(name, data);
  }

  Message.empty(): this('');

  String toPacket() {
    if (data == null) {
      return name;
    }
    return '$name:${JSON.encode(data)}';
  }
}