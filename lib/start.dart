library start;

import 'server.dart';

start(Server server, String hostAddress, int tcpPort) {
  server.listen(hostAddress, tcpPort);
}