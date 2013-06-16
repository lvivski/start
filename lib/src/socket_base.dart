library start_socket;

typedef void MsgHandler(data);

abstract class SocketBase {
  void send(String msg_name, { data });
  SocketBase on(Object message_name, MsgHandler action);
  void close([int status, String reason]);
}