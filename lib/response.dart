#library('response');

#import('dart:io');
#import('cookie.dart');

class Response {
    HttpResponse response;

    Response (this.response);

    Response header (String name, [value]) {
        if (value == null) {
            return response.header[name];
        }
        response.setHeader(name, value);
        return this;
    }

    Response get (String hame) => header(name);

    Response set (name, value) => header(name, value);

    Response type (contentType) => set('Content-Type', value);

    Response cache (String type, [Map options]) {
        if(options == null) {
            options = {};
        }
        String value = type;
        options.forEach((key, value) {
            value += ', ${key}=${value}';
        });
        return set('Cache-Control', value);
    }

    Response status (code) {
        response.statusCode = code;
        return this;
    }

    Response cookie (name, val, [Map options]) {
        if(options == null) {
            options = {};
        }
        options['name'] = name;
        options['value'] = val;
        var cookie = Cookie.stringify(options);
        return header('Set-Cookie', cookie);
    }

    Response deleteCookie (name) {
        Map options = { expires: new Date(1), path: '/' };
        return cookie(name, '', options);
    }

    send (String string) {
        response.outputStream.write(string.charCodes());
        response.outputStream.close();
    }

    sendfile (path) {
        var file = new File(path);
        file.exists((found) {
            if (found) {
                file.openInputStream().pipe(response.outputStream);
            } else {
                response.statusCode = HttpStatus.NOT_FOUND;
                response.outputStream.close();
            }
        });
    }

    json (data) {
        if(data is Map) {
            data = JSON.stringify(data);
        }
        send(data);
    }

    redirect (url, [int code = 302]) {
        response.statusCode = code;
        header('Location', url);
        response.outputStream.close();
    }
}
