import 'dart:io';
import 'lib/src/compiler.dart';

void main() {
  var compiledViews = new File('views/views.dart');

  compiledViews.exists().then((exists) {
    if (exists) {
      compiledViews.delete().then((_) => Compiler.compile('views'));
    } else {
      Compiler.compile('views');
    }
  });
}
