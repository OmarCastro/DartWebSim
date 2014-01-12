part of webdriver;

abstract class WebDriverAjax{
  String url;
  Future _request(String method, String path,[Object data = const {},bool parseValue = true]){
    HttpRequest req = new HttpRequest();
    Completer completer = new Completer();
    req.open('POST', 'http://localhost:4444/wd/hub/xdrpc', async:true );
    req.setRequestHeader("accept", "application/json");
    req.setRequestHeader("content-type", "application/json;charset=UTF-8");
    req.onReadyStateChange.listen((_){
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200){
          print(req.responseText);
          int index = req.responseText.lastIndexOf("}");
          String response = req.responseText.substring(0, index+1);
          Map responseMap = JSON.decode(response);
          if(responseMap["status"] != 0){
            String msg = responseMap['value']['message'];
            print(msg.substring(0, msg.indexOf("Capabilities"))); 
            completer.complete(null); 
          } else {
            completer.complete(parseValue ? responseMap['value'] : responseMap); 
          }
        }
      }
    });
    String body = JSON.encode({
      "method":method,
      "path":path,
      "data":data
    });
    print(body);
    req.send(body);
    return completer.future;
  }
  
  Future _post(String path,[Object data = const {}]) => _request("POST",path,data, false);
  Future _get(String path) => _request("GET",path,const {}, false);
  Future _delete(String path,[Object data = const {}]) => _request("DELETE",path,data, false);
  Future _put(String path,[Object data = const {}]) => _request("PUT",path,data, false);
}