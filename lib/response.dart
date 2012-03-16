#library('response');

class Response {
    HttpResponse response;

    Response(this.response);

    send(String string) {
        response.outputStream.write(string.charCodes());
        response.outputStream.close();
    }
}

