part of start;

class Request {
  final HttpRequest _request;
  Response response;
  Map params;
  Map getParams;
  Map postParams;
  Map urlParams;

  Request(this._request, this.urlParams){

//    Add url params
    params = urlParams;

//    Add get params
    getParams = _request.uri.queryParameters;
    for(int i = 0; i < getParams.length; i++){
      String getParamKey = getParams.keys.elementAt(i);
      String getParamValue = getParams.values.elementAt(i);
      if(!params.containsKey(getParamKey)){
        params[getParamKey] = getParamValue;
      }
    }

//    Add post params
    List<List<int>> buffer = [];
    _request.listen((data){buffer.add(data);}, onDone: (){
      if(buffer.isNotEmpty){
        String dataString = new String.fromCharCodes(buffer[0]);
        List<String> dataPairs = dataString.split("&");
        for(var dataPair in dataPairs){
          var dataSplit = dataPair.split("=");
          var key = dataSplit[0];
          var value = dataSplit[1];
          postParams[key] = value;
          if(params[key] == null) params[key] = value;
        };
      }
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

  String param(String name, {method}) {
//    Checks if key is in specified array, if not return null, key assumed to be name
    dynamic valueIfExists(Map map, {String key}){

      if(key == null) key = name;

      if(map.containsKey(key)){
        return map[key];
      } else {
        return null;
      }
    }

    switch (method){
      case 'url':
        return valueIfExists(urlParams);
        break;
      case 'get':
        return valueIfExists(getParams);
        break;
      case 'post':
        return valueIfExists(postParams);
        break;
      default:
        return valueIfExists(params);
    }
  }
}
