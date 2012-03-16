#library('request');

class Request {
    HttpRequest request;

    Request(this.request);

    String header(String name) => request.headers[name.toLowerCase()];

    bool accepts(Sring type) {
        return request.headers['accept'].split(',').indexOf(type) >= 0;
    }

    bool isMime(String type) {
        return request.headers['content-type'].contains(type);
    }

    param(String name) => request.queryParameters[name];
}
