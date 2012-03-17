#library('request');

class Request {
    HttpRequest request;
    Map params;

    Request (this.request);

    String header (String name) => request.headers[name.toLowerCase()];

    bool accepts (Sring type) {
        return request.headers['accept'].split(',').indexOf(type) >= 0;
    }

    bool isMime (String type) {
        return request.headers['content-type'].contains(type);
    }

    bool isForwarded () {
        return request.header.containsKey('x-forwarded-host');
    }

    get uri() => request.uri;

    param (String name) {
        if (params.containsKey(name)) {
            return params[name];
        }
        return request.queryParameters[name];
    }

    setParams(Map reqParams) {
        params = reqParams;
    }
}
