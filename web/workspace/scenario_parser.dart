library parser;
import 'package:parsers/parsers.dart';
import '../scenario/scenario.dart';

part 'tokens.dart';

/* TOKENS */


final scenarioParser = (scenarioLineCommand|elementStates).sepBy(char('\n').skipMany1) ^ 
(List values){
  List scenarioSteps = [];
  ScenarioElement currentElement = null;
  values.forEach((el){
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

final scenarioLineCommand = string("I ") + user_command ^ (_,test) => test;


final user_command =  (goToPageLine|writeLine|clickit|markElement|getElement|wait);
final goToPageLine = (string('go to page ') + sstring) ^ (_,String url) => new GoToUrlStep(url);

final clickit = string("click it") ^ (_) => new ClickElementStep();

final writeLine = (string('write ') + sstring) ^ (_,str) => new WriteStep(str);

final onElement = (string(" on ") + sstring);


final markElement = string("mark element of ") + element
          + spaces + string("as") + spaces + sstring ^ markElementCommand;


final getElement = string("get element of ") + element ^ (_,states) => states;

final wait = waitToken + (waitSeconds|waitMiliSeconds) ^ (_,duration) => new WaitStep(duration);
final waitSeconds = integerToken + string(" seconds") ^ (dur,_) => new Duration(seconds: dur);
final waitMiliSeconds = integerToken + string(" milliseconds") ^ (dur,_) => new Duration(milliseconds: dur);





final Parser elementStates = string("It ") + (containsText|isVisible|isNotVisible) ^ (_,condition) => condition;
final Parser containsText = string("contains ") + sstring ^ (_,text) => new SearchTextElementStep(text, true);
final Parser isVisible = string("is visible") ^ (_) => new VisibilityElementStep(true);
final Parser isNotVisible = string("is invisible") ^ (_) => new VisibilityElementStep(true);

// == Element ==
final Parser element = (markByID|markByCSS|markByName|markByXPath);
final Parser markByID = string("Id ") + sstring ^ (_,text) => new GetElementStep()..ofID(text);
final Parser markByCSS = string("CSS ") + sstring ^ (_,text)=>new GetElementStep()..ofCssSelector(text);
final Parser markByName = string("name ") + sstring ^ (_,text)=>new GetElementStep()..ofName(text);
final Parser markByXPath = string("xpath ") + sstring ^ (_,text)=>new GetElementStep()..ofXPath(text);






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

