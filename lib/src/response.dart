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

  Response add(String string) {
    _response.write(string);
    return this;
  }

  Response attachment(String filename) {
    if (filename != null) {
      return set('Content-Disposition', 'attachment; filename="${filename}"');
    }
    return this;
  }

  Response mime(String path) {
    var mimeType = lookupMimeType(path);
    if (mimeType != null) {
      return type(mimeType);
    }
    return this;
  }

  Future send(String string) {
    _response.write(string);
    return _response.close();
  }

  Future sendFile(String path) {
    var file = new File(path);

    return file.exists()
        .then((found) => found ? found : throw 404)
        .then((_) => file.length())
        .then((length) => header('Content-Length', length))
        .then((_) => mime(file.path))
        .then((_) => file.openRead().pipe(_response))
        .then((_) => _response.close())
        .catchError((_) {
          _response.statusCode = HttpStatus.NOT_FOUND;
          return _response.close();
        }, test: (e) => e == 404);
  }

  Future close() {
    return _response.close();
  }

  Future json(data) {
    if (data is Map || data is List) {
      data = JSON.encode(data);
    }

    if (get('Content-Type') == null) {
      type('application/json');
    }

    return send(data);
  }

  Future jsonp(String name, data) {
    if (data is Map) {
      data = JSON.encode(data);
    }
    return send("$name('$data');");
  }

  Future redirect(String url, [int code = 302]) {
    _response.statusCode = code;
    header('Location', url);
    return _response.close();
  }
}
