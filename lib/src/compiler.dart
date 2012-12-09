library compiler;

import 'dart:io';
import '../../packages/hart/hart.dart';

class Compiler {
  static compile(String inputDir) {
    DirectoryLister lister = new Directory(inputDir).list();
    Map templates = {};

    lister.onFile = (String filePath) {
      var file = new File(filePath);
      String template = file.readAsStringSync();
      String name = file.name.split('/').last.split('.')[0];
      templates[name] = template;
    };
    
    lister.onDone = (bool done) {
      if (done) {
        new File('$inputDir/views.dart').open(FileMode.WRITE).then((file) {
          file.writeString(Hart.compile(templates));
        });  
      }
    };
  }
}