/* 
 *  DartWebSim a a web application to create web acceptance tests or to simulate commands 
 * 
 *  Copyright (c) 2013 Omar Castro 
 */

import 'dart:html';
import 'workspace/scenario_div.dart';
import 'package:ace/ace.dart' as ace;



void main() {
  
  ace.require('ace/ext/language_tools');
  
  ace.Editor editor = ace.edit(querySelector('#editor'))
  
  ..theme = new ace.Theme('ace/theme/twilight')
  ..session.mode = new ace.Mode('ace/mode/websim')
  ..setOptions({
    'enableBasicAutocompletion' : true,
    'enableSnippets' : true
  });  
  
  Element runButton = querySelector("#runtests");
  Element fileButton = querySelector("#file");
  Element loadButton = querySelector("#loadButton");
  loadButton.onClick.listen((_){fileButton.click();});
  runButton.onClick.listen((ev){
    
    ScenarioHtml.runScenario(editor.value);

  });


}


