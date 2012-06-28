#library('compiler');

#import('dart:io');
#import('package:hart/lib/hart.dart');

class Compiler {
  static _getClass(String className, String data) {
    return """

class ${className}View extends View {
  Map locals;

  ${className}View(this.locals);

  noSuchMethod(String name, List args) {
    if (locals === null) {
      locals = {};
    }
    if (name.length > 4) {
      String prefix = name.substring(0, 4);
      String key   = name.substring(4);
      if (prefix == "get:") {
        return locals[key];
      } else if (prefix == "set:") {
        locals[key] = args[0];
      }
    }
  }

  get () {
    return '''
$data
    ''';
  }
}
""";
  }
  
  static _getMain(List templates) {
    var buff = new StringBuffer('''

class View {
  Map _views;
  
  render(name, params) {
    return _views[name](params).get();
  }
  
  register(name, handler) {
    if (_views == null) {
      _views = {};
    }
    _views[name] = handler;
  }

  View() {
''');
    templates.forEach((template) {
      buff.add("    register('$template', (params) => new ${camelize(template)}View(params));\n");
    });
    buff.add('''
   }
}
''');
    return buff.toString();
  }
  
  static compile(String inputDir) {
    DirectoryLister lister = new Directory(inputDir).list(true);
    StringBuffer buff = new StringBuffer('''
#library('view');
#import('package:hart/lib/utils.dart');
''');
    List templates = [];

    lister.onFile = (String filePath) {
      var file = new File(filePath);
      var data = file.readAsTextSync(Encoding.UTF_8);
      String template = file.name.split('/').last().split('.')[0];
      buff.add(_getClass(camelize(template), Hart.parse(data)));
      templates.add(template);
    };
    
    lister.onDone = (bool done) {
      if (done) {
        buff.add(_getMain(templates));
        new File('$inputDir/views.dart').open(FileMode.WRITE).then((file) {
          file.writeString(buff.toString());
        });  
      }
    };
  }
  
  static String camelize(String name) {
    return Strings.join(name.split(const RegExp(@'-|_')).map((part) => part[0].toUpperCase().concat(part.substring(1))), '');
  }
}