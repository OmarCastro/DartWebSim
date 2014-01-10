/*
 * Web-based webdriver uses ajax to communicate with the selenium webdriver
 * 
 * Copyright (c) 2013 Omar Castro 
 */


library webdriver;
import 'dart:html';
import 'dart:async';
import 'dart:convert';

part 'ajax.dart';
part 'session.dart';

class WebDriver extends Object with WebDriverAjax{
  WebDriver(String url){
    this.url = url+"/xdrpc";
  }
  
  Future<WebDriverSession> newSession([
       browser = 'chrome', Map additional_capabilities]) {
    Completer completer = new Completer();
     if (additional_capabilities == null) {
       additional_capabilities = {};
     }
     
     additional_capabilities['browserName'] = browser;
    _post("/session", {"desiredCapabilities":additional_capabilities}).then((Map ev){
      completer.complete(new WebDriverSession(this.url, ev));
    });
    return completer.future;
  }
}