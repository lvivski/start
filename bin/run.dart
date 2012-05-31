#import('dart:io');

final DART_PATH = '/Applications/Dart/dart-sdk/';

startServerProcess() {
  var serverProcess = Process.start("$DART_PATH/bin/dart", ["app.dart"]);
  var stdoutStream = new StringInputStream(serverProcess.stdout);
  stdoutStream.onLine = () => print(stdoutStream.readLine());
}

void main() {
  Process.run("$DART_PATH/bin/pub", ["install"])
  .chain((_) => Process.run("$DART_PATH/bin/dart", ["compile.dart"]))
  .then((_) => startServerProcess());
}