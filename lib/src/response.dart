part of start;

class Response {
  HttpResponse _response;
  var _view;

  Response(this._response, [this._view]);

  header(String name, [value]) {
    if (value == null) {
      return _response.headers[name];
    }
    _response.headers.set(name, value);
    return this;
  }

  Response get(String name) => header(name);

  Response set(String name, String value) => header(name, value);

  Response type(String contentType) => set('Content-Type', contentType);

  Response cache(String cacheType, [Map<String,String> options]) {
    if(options == null) {
      options = {};
    }
    StringBuffer value = new StringBuffer(cacheType);
    options.forEach((key, val) {
      value.write(', ${key}=${val}');
    });
    return set('Cache-Control', value.toString());
  }

  Response status(int code) {
    _response.statusCode = code;
    return this;
  }

  Response cookie(String name, String val, [Map options]) {
    if (options == null) {
      options = {};
    }
    options['name'] = name;
    options['value'] = val;
    var cookieHeader = Cookie.stringify(options);
    return header('Set-Cookie', cookieHeader);
  }

  Response deleteCookie(String name) {
    Map options = { 'expires': 'Thu, 01-Jan-70 00:00:01 GMT', 'path': '/' };
    return cookie(name, '', options);
  }

  add(String string) {
    _response.write(string);
  }

  send(String string) {
    _response.write(string);
    _response.close();
  }

  close() {
    _response.close();
  }

  sendFile(String path) {
    var file = new File(path);
    file.exists().then((found) {
      if (found) {
        file.openRead().pipe(_response);
      } else {
        _response.statusCode = HttpStatus.NOT_FOUND;
        _response.close();
      }
    });
  }

  json(data) {
    if (data is Map) {
      data = Json.stringify(data);
    }
    send(data);
  }

  jsonp(String name, data) {
    if (data is Map) {
      data = Json.stringify(data);
    }
    send("$name('$data');");
  }

  redirect(String url, [int code = 302]) {
    _response.statusCode = code;
    header('Location', url);
    _response.close();
  }

  render(String viewName, [Map params]) {
    header('Content-Type', 'text/html; charset=UTF-8')
    .send(_view.render(viewName, params));
  }
}
