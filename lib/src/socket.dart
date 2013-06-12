library start_socket;

typedef void MsgHandler(data);

abstract class Socket {
  void send(String msg_name, { data });
  Socket on(Object message_name, MsgHandler action);
  void close([int status, String reason]);
}