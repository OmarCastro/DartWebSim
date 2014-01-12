/* 
 *  DartWebSim a a web application to create web acceptance tests or to simulate commands 
 * 
 *  Copyright (c) 2013 Omar Castro 
 */

import 'dart:html';
import 'package:parsers/parsers.dart';
import 'workspace/scenario_parser.dart';
import 'scenario/scenario.dart';
import 'webdriver/selenium_webdriver.dart';
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
    final ParseResult result = scenarioParser.run(editor.value);
    if(result.isSuccess){
      print(result.value);

      var driver = new WebDriver('http://localhost:4444/wd/hub');
      driver.newSession().then((WebDriverSession session){
        Scenario scenario = new Scenario()..session=session;
        var user = scenario.as("user");
          user.steps = result.value;
          scenario.start(); 
      });
    } else {
      editor.session.annotations = 
          [new ace.Annotation(row: result.position.line-1,
                              text: result.errorMessage,
                              type: ace.Annotation.ERROR),
           ];
    }
    
  });


}


