part of parser;

final HLParser = HLCommand + spaces + eof ^ (_,spaces,eof) => _;

final HLCommand =  (HLUserCommand | HLElementCommand);

final HLUserCommand = string("I ") + (HLwriteLine|HLgoToPage|HLwait|HLgetElement) ^ join_strs;

final HLElementCommand = oneOf("Ii") + string('t ') + (HLContains|HLConditional) ^ join_strs;

final HLConditional = string("is ") + (HLDisplayed|HLNotDisplayed|HLElementName) ^ join_strs;

final HLDisplayed = string("visible") ^ (_) => span(_,"attribute");
final HLNotDisplayed = string("invisible") ^ (_) => span(_,"attribute");
final HLElementName = HLstring;

final HLContains = (HLdoesNotContain | (string("contains")))
+ HLstring ^ join_strs;

final HLdoesNotContain = HLdoesNot + string("contain ") ^ join_strs;
final HLdoesNot = string("does") + (string("n't ") | string(" not ")) ^ join_strs;


final HLwriteLine = (string('write ') + HLstring + HLonElement.maybe) ^ (_1,_2,_3)=>"$_1$_2${_3.orElse("")}";
final HLonElement = (string(" on ") + HLstring) ^ join_strs;

final HLgoToPage = string('go ') + string("to ") + string("page ") + HLUrlString ^ join_strs;


final HLwait = waitToken +  HLintegerToken + spaces + (string("seconds")|string("milliseconds")) + space.many ^ 
(wait,digits,__,time,_) => "$wait $digits ${span(time,"attribute")}${_.join()}";


final HLgetElement = string("get element of") + HLelement ^ (token,elem) => "$token $elem";

final HLelement = char(' ') + (string("id ") | string("css ") | string("name ") | string("xpath "))
 + HLstring ^ (__,text,str) => "${span(text,"selector")}$str";


final HLUrlString = sstring ^ (String str)=> '<a href="$str" class="str">$str</a>';
final HLstring = (HLdquotestring | HLquotestring | HLunquotestring) ^ (String str) => span(str,"str");

final HLquotestring  = quotestringToken ^ (_,str,s) => _+str.join()+s.orElse("");
final HLdquotestring = dquotestringToken ^ (_,str,s) => _+str.join()+s.orElse("");
final HLunquotestring = unquotestringToken ^(List txt)=>txt.join();


final HLintegerToken = digit.many1 ^ (number) => span(number.join(),"number");


String span(String text,String span_class) => '<span class="$span_class">$text</span>';
