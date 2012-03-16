#library('response');

#import('dart:json');
#import('dart:io');

class Response {
    HttpResponse response;

    Response (this.response);

    send (String string) {
        response.outputStream.write(string.charCodes());
        response.outputStream.close();
    }

    header (String name, [value]) {
        if (value == null) {
            return response.header[name];
        }
        response.setHeader(name, value);
    }

    status ([int code]) {
        if (code == null) {
            return response.statusCode;
        }
        response.statusCode = code;
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
