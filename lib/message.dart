#library('message');

class Message {
  String _command;
  Map params;
  
  Message(String this._command, Map this.params);

  Message.start(String host,
                int port)
      : _command = 'start' {
   params = {
     'host': host,
     'port': port
   };
  }
  
  Message.stop() : _command = 'stop';

  bool get isStart() => _command == 'start';
  bool get isStop() => _command == 'stop';
  bool get isAdd() => _command == 'add';
}
