#library('view');
#import('package:hart/lib/utils.dart');

class IndexView extends View {
  Map locals;

  IndexView(this.locals);

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
<!DOCTYPE html>\n<html>\n<head>\n<title>${escape(title)}</title>\n<link${attrs({ 'rel': "stylesheet", 'href': "/stylesheets/main.css", 'type': "text/css"})}/></head>\n<body>\n<h1>${escape(title)}</h1>\n<p>is awesome</p></body></html>
    ''';
  }
}

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
    register('index', (params) => new IndexView(params));
   }
}
