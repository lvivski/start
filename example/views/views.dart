library view;
import 'dart:mirrors';
import 'package:hart/utils.dart';

class IndexView extends View {
  Map locals;

  IndexView(this.locals);

  noSuchMethod(Invocation mirror) {
    if (locals == null) {
      locals = {};
    }
    if (mirror.isGetter) {
      return locals[MirrorSystem.getName(mirror.memberName)];
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

  render(String name, Map params) {
    return _views[name](params).get();
  }

  register(String name, handler(Map params)) {
    if (_views == null) {
      _views = {};
    }
    _views[name] = handler;
  }

  View() {
    register('index', (params) => new IndexView(params));
   }
}
