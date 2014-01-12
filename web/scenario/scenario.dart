library testScenario;
import 'dart:async';
import '../webdriver/selenium_webdriver.dart';

part 'scenario_element.dart';


class Scenario{
  WebDriverSession session;
  ScenarioUser user;
  ScenarioUser as(String role){
    user = new ScenarioUser(session);
    return user;
  }
  start() => user._begin().then((_)=>session.close());
}


class ScenarioUser{
  
  List<ScenarioStep> steps = [];
  int stepNumber = 0;
  WebDriverSession session;
  Completer completer;
  Map<String, ScenarioElement> markedElements;

  
  ScenarioUser(this.session);
  void goToPage(String url) => steps.add(new GoToUrlStep(url));
  GetElementStep get getElement => _add(new GetElementStep());
  WriteStep write(String text) => _add(new WriteStep(text));
  
  void wait(Duration duration) => steps.add(new WaitStep(duration));
  
  ScenarioStep _add(ScenarioStep step){
    steps.add(step);
    return step;  
  }
  
  Future _begin(){
    completer = new Completer();
    stepNumber = 0;
    steps[stepNumber].run(this).then(_nextStep);
    return completer.future;
  }
  
  void _nextStep(_){
    stepNumber++;
    if(stepNumber < steps.length){
      steps[stepNumber].run(this).then(_nextStep);
    }else{
      completer.complete();
    }
    
    
  }
}


abstract class ScenarioStep{
  Future run(ScenarioUser user);
}

class GoToUrlStep extends ScenarioStep{
  String url;
  GoToUrlStep(this.url);
  Future run(ScenarioUser user) => user.session.setUrl(url);
}


class GetElementStep extends ScenarioStep{
  String value;
  String strategy;
  ScenarioElement element;
  GetElementStep(){
    element = new ScenarioElement(this);
  }
  
  ScenarioElement ofName(String name){          strategy = "name"                 ;value = name; return element;}
  ScenarioElement ofCssSelector(String css){    strategy = "css selector"         ;value = css; return element;}
  ScenarioElement ofID(String id){              strategy = "id"                   ;value = id; return element;}
  ScenarioElement ofXPath(String xpath){        strategy = "xpath"                ;value = xpath; return element;}
  ScenarioElement ofTag(String tag){            strategy = "tag"                  ;value = tag; return element;}
  ScenarioElement byClassName(String className){strategy = "class name"           ;value = className; return element;}
  ScenarioElement anchorText(String text,bool partial){strategy = "${partial?"partial ":""}link text";value = text; return element;}
  Future run(ScenarioUser user) => element.run(user.session,strategy, value);
}

class WriteStep extends ScenarioStep{
  String content;
  ScenarioElement _element;
  List<String> keys;
  WriteStep(String this.content){
    content = content.split("\\n").join("\n");
    keys = content.split("");
  }
  void on(ScenarioElement element){_element = element;}
  void onElementMarkedBy(String str){}
  Future run(ScenarioUser user) => 
      (_element == null) ? 
          user.session.sendKeyStrokes(keys) :
          user.session.sendKeyStrokesToElement(_element.elementId, keys);
}

class WaitStep extends ScenarioStep{

  Duration duration;
  WaitStep(this.duration);
  Future run(ScenarioUser user){
    Completer completer = new Completer();
    new Timer(duration,()=> completer.complete(true));
    return completer.future;
  }

}
