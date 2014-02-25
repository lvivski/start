part of start;

class Response {
  HttpResponse _response;

  Response(this._response);

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
    var cookie = new Cookie(
          Uri.encodeQueryComponent(name),
          Uri.encodeQueryComponent(val)
        ),
        cookieMirror = reflect(cookie);

    if (options != null) {
      options.forEach((option, value) {
        cookieMirror.setField(new Symbol(option), value);
      });
    }

    _response.cookies.add(cookie);
    return this;
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

  json(data) {
    if (data is Map || data is List) {
      data = JSON.encode(data);
    }
    send(data);
  }

  jsonp(String name, data) {
    if (data is Map) {
      data = JSON.encode(data);
    }
    send("$name('$data');");
  }

  redirect(String url, [int code = 302]) {
    _response.statusCode = code;
    header('Location', url);
    _response.close();
  }
}
