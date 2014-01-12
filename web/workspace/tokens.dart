part of parser;


final sstring = unquotestring;
final quotestring  = quotestringToken ^ (_,str,s) => str.join();
final dquotestring = dquotestringToken ^ (_,str,s) => str.join();
final unquotestring = unquotestringToken ^(List txt)=>txt.join();


final quotestringToken  = (oneOf('"') + unquotestringToken + oneOf('"').maybe);
final dquotestringToken = (oneOf("'") + unquotestringToken + oneOf("'").maybe);
final unquotestringToken = noneOf('\n').many1;

final integerToken = digit.many1 + spaces ^ (List number,_) => int.parse(number.join());




final waitToken = string("wait") + spaces ^ (wait,__) => wait;

String join_strs([_1 = "",_2 = "",_3 = "",_4 = "",_5 = "",_6 = ""]) => "$_1$_2$_3$_4$_5$_6";

final endofcommand = newline | eof;
