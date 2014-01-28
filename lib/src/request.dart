part of start;

class Request {
  final HttpRequest _request;
  Response response;
  Map params;

  Request(this._request){
    List<List<int>> buffer = [];
    _request.listen((data){buffer.add(data);}, onDone: (){
      String dataString = new String.fromCharCodes(buffer[0]);
      List<String> dataPairs = dataString.split("&");
      for(var dataPair in dataPairs){
        var dataSplit = dataPair.split("=");
        var key = dataSplit[0];
        var value = dataSplit[1];
        if(params[key] == null){
          params[key] = value;
        } else {
          params["POST_"+key] = value;
        }
      };
    });
  }

  List header(String name) => _request.headers[name.toLowerCase()];

  bool accepts(String type) =>
      _request.headers['accept'].where((name) => name.split(',').indexOf(type) ).length > 0;

  bool isMime(String type) =>
      _request.headers['content-type'].where((value) => value == type).isNotEmpty;

  bool get isForwarded => _request.headers['x-forwarded-host'] != null;

  HttpRequest get input => _request;

  String get path => _request.uri.path;

  Uri get uri => _request.uri;

  String param(String name) {
    if (params.containsKey(name) && params[name] != null) {
      return params[name];
    }
    return _request.uri.queryParameters[name] != null
         ? _request.uri.queryParameters[name]
         : '';
  }

}
