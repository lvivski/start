#import('dart:io');

final DART_PATH = '/Applications/Dart/dart-sdk/';

void main() {
  Process.run("$DART_PATH/bin/pub", ["install"])
  .chain((_) => Process.run("$DART_PATH/bin/dart", ["compile.dart"]))
  .then((_) => Process.run("$DART_PATH/bin/dart", ["app.dart"]));
}