import 'dart:io';

final DART_PATH = '/Applications/Dart IDE/dart-sdk/';

startServerProcess() {
  Future<Process> serverProcessFuture = Process.start("$DART_PATH/bin/dart", ["app.dart"]);
  serverProcessFuture.then((process) {
    var stdoutStream = new StringInputStream(process.stdout);
    stdoutStream.onLine = () => print(stdoutStream.readLine());  
  });
}

void main() {
  Process.run("$DART_PATH/bin/pub", ["install"])
  .chain((_) => Process.run("$DART_PATH/bin/dart", ["compile.dart"]))
  .then((_) => startServerProcess());
}