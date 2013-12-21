import 'dart:html';
import 'scenario/scenario.dart';
import 'webdriver/selenium_webdriver.dart';
import 'workspace/scenario_div.dart';
//import 'package:webdriver/webdriver.dart';




void main() {
  
  Element runButton = querySelector("#runtests");
  Element fileButton = querySelector("#file");
  Element loadButton = querySelector("#loadButton");
  loadButton.onClick.listen((_){fileButton.click();});
  runButton.onClick.listen((ev){
    
    ScenarioHtml.runScenario(querySelector(".TestWorkspace"));
/*
    
    var driver = new WebDriver('http://localhost:4444/wd/hub');
    driver.newSession().then((WebDriverSession session){
      
      
      /*Scenario scenario = new Scenario()..session=session;
      ScenarioUser I = scenario.as("Genius");
      
      I.goToPage("http://www.google.com");
      ScenarioElement searchBox = I.getElement.ofName("q");
      //ScenarioElement searchButton = I.getElement.ofName("btnK");
  
      I.write("hello").on(searchBox);
      I.wait(const Duration(seconds: 3));
      scenario.start();*/
    });*/
  });
  ScenarioHtml.addScenario();

}


