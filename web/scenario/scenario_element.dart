part of testScenario;


/**
 * Web Element to be used on a Scenario
 */
class ScenarioElement{
  GetElementStep step;
  int subStepNumber;
  List<ScenarioElementStep> substeps = [];
  ScenarioElement and;
  String elementId;
  Completer completer;
  ScenarioElement(this.step){and = this;}
  void isDisplayed() => substeps.add(new VisibilityElementStep(true));
  void isntDisplayed() => substeps.add(new VisibilityElementStep(false));
  void containsText(Pattern pattern)
    => substeps.add(new SearchTextElementStep(pattern,true));
  
  void doesntContainText(Pattern pattern)
    => substeps.add(new SearchTextElementStep(pattern,true));

  
  Future run(WebDriverSession session,String strategy, String value){
    completer = new Completer();
    session.findElement(strategy, value).then((Map val){
      print(val);
      elementId = val['ELEMENT'];
      start(session,completer);
    });
    return completer.future;
    
  }
  
  void start(WebDriverSession session, Completer completer){
    subStepNumber = -1;
    nextStep(session,completer);
  }
  
  void nextStep(WebDriverSession session, Completer completer){
    subStepNumber++;
    if(subStepNumber < substeps.length){
      substeps[subStepNumber].run(session,elementId).then((_){nextStep(session,completer);});
    } else {
      completer.complete(true);
    }
  }
}

abstract class ScenarioElementStep{
  Future run(WebDriverSession session, String id);
}
class VisibilityElementStep extends ScenarioElementStep{
  Pattern pattern;
  bool trueOnVisible;
  VisibilityElementStep(bool this.trueOnVisible);
  Future run(WebDriverSession session, String id){
    Completer completer = new Completer();
    session.isDiplayed(id).then((bool isVisible){
      completer.complete(trueOnVisible ? isVisible : !isVisible);
    });
    return completer.future;
  }
}

class SearchTextElementStep extends ScenarioElementStep{
  Pattern pattern;
  bool trueIfContains;
  SearchTextElementStep(this.pattern, this.trueIfContains);
  Future run(WebDriverSession session, String id){
    Completer completer = new Completer();
    session.getElementText(id).then((String text){
      bool contains = text.contains(pattern);
      completer.complete(trueIfContains ? contains : !contains);
    });
    return completer.future;
  }
}
