import 'dart:io';
import 'package:start/src/compiler.dart';

void main() {
  var args = new Options().arguments,
      path = args.length > 0 ? args[0] : 'example/views',
      compiledViews = new File('$path/views.dart'),
      callback = (_) => Compiler.compile(path);

  compiledViews.exists().then((exists) {
    if (exists) {
      compiledViews.delete().then(callback);
    } else {
      callback(true);
    }
  });
}