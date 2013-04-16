library view;
import 'package:hart/utils.dart';

class IndexView extends View {
  Map locals;

  IndexView(this.locals);

  noSuchMethod(Invocation mirror) {
    if (locals == null) {
      locals = {};
    }
    if (mirror.isGetter) {
      return locals[mirror.memberName];
    }
  }

  get() {
    return '''
<!DOCTYPE html>\n<html>\n<head>\n<title>${escape(title)}</title>\n<link${attrs({'rel':"stylesheet", 'href':"/stylesheets/main.css", 'type':"text/css"})}/>\n<script${attrs({'type':"application/dart", 'src':"/scripts/script.dart"})}></script>\n<script${attrs({'type':"text/javascript", 'src':"packages/browser/dart.js"})}></script></head>\n<body>\n<h1>${escape(title)}</h1>\n<p>is awesome</p></body></html>
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
