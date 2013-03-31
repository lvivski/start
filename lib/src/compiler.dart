library compiler;

import 'dart:io';
import 'package:hart/hart.dart';

class Compiler {
  static compile(String inputDir) {
    var lister = new Directory(inputDir).list();
    var templates = {};

    lister.listen((file) {
      if (file is File) {
        var template = file.readAsStringSync();
        var name = file.path.split('/').last.split('.')[0];
        templates[name] = template;
      }
    }, onDone: () {
      new File('$inputDir/views.dart').open(mode: FileMode.WRITE).then((file) {
        file.writeString(Hart.compile(templates));
      });
    });
  }
}