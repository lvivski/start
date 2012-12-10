import 'dart:io';
import 'package:start/src/compiler.dart';

void main() {
  var path = 'example/views',
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