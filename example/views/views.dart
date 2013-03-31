library view;
import 'package:hart/utils.dart';

class IndexView extends View {
  Map locals;

  IndexView(this.locals);

  noSuchMethod(InvocationMirror mirror) {
    if (locals == null) {
      locals = {};
    }
    if (mirror.isGetter) {
      return locals[mirror.memberName];
    }
  }

  get() {
    return '''
<!DOCTYPE html>\n<html>\n<head>\n<title>${escape("Start with Twitter Bootstrap")}</title>\n<link${attrs({'rel':"stylesheet", 'href':"/stylesheets/bootstrap.css", 'type':"text/css"})}/>\n<link${attrs({'rel':"stylesheet", 'href':"/stylesheets/bootstrap-responsive.css", 'type':"text/css"})}/>\n<script${attrs({'type':"application/dart", 'src':"/scripts/script.dart"})}></script>\n<script${attrs({'type':"text/javascript", 'src':"packages/browser/dart.js"})}></script></head>\n<body>\n<h2>${escape(title)}</h2>\n<p>is awesome</p>\n<input${attrs({'type':"text", 'placeholder':"Type something..."})}/>\n<input${attrs({'type':"button", 'class':"btn btn-primary", 'value':"Click here"})}/></body></html>
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
