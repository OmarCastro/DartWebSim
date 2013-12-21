library parser;
import 'package:parsers/parsers.dart';
import '../scenario/scenario.dart';

part 'tokens.dart';
part 'syntax_highlight.dart';


/* TOKENS */


final scenarioText = scenarioLineCommand.sepBy(char('\n'));

final scenarioLineCommand = string("I ") + user_command ^ (_,test) => test;

final user_command =  (goToPageLine|writeLine|markElement|getElement|wait);
final goToPageLine = (string('go to page ') + sstring) ^ (_,String url) => new GoToUrlStep(url);


final writeLine = (string('write ') + sstring) ^ (_,str) => new WriteStep(str);

final onElement = (string(" on ") + sstring);
final markElement = string("mark element of ") + element
          + spaces + string("as") + spaces + sstring ^ markElementCommand;


final getElement = string("get element of ") + element ^ (_,elem) => elem;

final wait = waitToken + (waitSeconds|waitMiliSeconds) ^ (_,duration) => new WaitStep(duration);
final waitSeconds = integerToken + string(" seconds") ^ (dur,_) => new Duration(seconds: dur);
final waitMiliSeconds = integerToken + string(" milliseconds") ^ (dur,_) => new Duration(milliseconds: dur);

// == Element ==
final element = (markByID|markByCSS|markByName|markByXPath);
final markByID = string("id ") + sstring ^ (_,text) => new GetElementStep()..ofID(text);
final markByCSS = string("css ") + sstring ^ (_,text)=>new GetElementStep()..ofCssSelector(text);
final markByName = string("name ") + sstring ^ (_,text)=>new GetElementStep()..ofName(text);
final markByXPath = string("xpath ") + sstring ^ (_,text)=>new GetElementStep()..ofXPath(text);

writeCommand(_,String textChars,elem){
  WriteStep step = new WriteStep(textChars);
  if(elem.asNullable != null){
    step.onElementMarkedBy(elem.asNullable);
  }
  return step;
}
String onElementCommand(_,elem) => elem;
markElementCommand(_,elem,___,__,____,mark) => elem;
