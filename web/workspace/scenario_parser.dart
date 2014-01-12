library parser;
import 'package:parsers/parsers.dart';
import '../scenario/scenario.dart';

part 'tokens.dart';

/* TOKENS */

List toSingleList(List list){
  return list.fold([], (List prev,current){
    if(current is List){
      prev.addAll(toSingleList(current));
    } else {
      prev.add(current);
    }
    return prev;
  });  
}

final scenarioParser = (scenarioLineCommand|elementStates).manyUntil(eof) ^ (List values){
    List scenarioSteps = [];
    ScenarioElement currentElement = null;
    toSingleList(values).forEach((el){
      if(el is ScenarioElementStep){
        currentElement.addSubstep(el);
        return;
      }
      if(el is GetElementStep){
         currentElement = el.element;
      }
      scenarioSteps.add(el);
    });
    return scenarioSteps;
};


final Parser scenarioLineCommand = string("I ") + user_command  ^ (_,test) => test;
final Parser elementStates = string("It ") + (containsText|isVisible|isNotVisible) 
+  endofcommand ^ (_,condition,__) => condition;


final user_command =  (goToPageLine|writeLine|clickit|markElement|getElement|wait) +  endofcommand ^ (_,__)=>_;
final goToPageLine = (string('go to page ') + sstring) ^ (_,String url) => new GoToUrlStep(url);

final clickit = string("click it") ^ (_) => new ClickElementStep();

final writeLine = (string('write') + spaces + sstring) ^ (_0,_1,str) => new WriteStep(str);

final onElement = (string(" on ") + sstring);


final markElement = string("mark element of ") + element
          + spaces + string("as") + spaces + sstring ^ markElementCommand;


final getElement = string("get ") + (element|anchorElement) ^ (_,states) => states;

final wait = waitToken + (waitSeconds|waitMiliSeconds) ^ (_,duration) => new WaitStep(duration);
final waitSeconds = integerToken + string("seconds") ^ (dur,_) => new Duration(seconds: dur);
final waitMiliSeconds = integerToken + string("milliseconds") ^ (dur,_) => new Duration(milliseconds: dur);





final Parser containsText = string("contains ") + sstring ^ (_,text) => new SearchTextElementStep(text, true);
final Parser isVisible = string("is visible") ^ (_) => new VisibilityElementStep(true);
final Parser isNotVisible = string("is invisible") ^ (_) => new VisibilityElementStep(true);

// == Element ==
final Parser element = string("element of") + spaces + (markByID|markByCSS|markByName|markByXPath) ^ (_,_0,__)=>__;
final Parser markByID = string("Id ") + sstring ^ (_,text) => new GetElementStep()..ofID(text);
final Parser markByCSS = string("CSS ") + sstring ^ (_,text)=>new GetElementStep()..ofCssSelector(text);
final Parser markByName = string("name ") + sstring ^ (_,text)=>new GetElementStep()..ofName(text);
final Parser markByClassName = string("class name ") + sstring ^ (_,text)=>new GetElementStep()..byClassName(text);
final Parser markByXPath = string("xpath ") + sstring ^ (_,text)=>new GetElementStep()..ofXPath(text);

final Parser anchorElement = string("link with ") + string("exact ").maybe + string("text") + spaces  + sstring ^ (_,opt,_0,_1,text) 
  => new GetElementStep()..anchorText(text,!opt.isDefined);





// == Functions ==

writeCommand(_,String textChars,elem){
  WriteStep step = new WriteStep(textChars);
  /*if(elem.asNullable != null){
    step.onElementMarkedBy(elem.asNullable);
  }*/
  return step;
}
String onElementCommand(_,elem) => elem;
markElementCommand(_,elem,___,__,____,mark) => elem;

