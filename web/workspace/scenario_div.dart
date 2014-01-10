import 'dart:html';
import 'scenario_parser.dart';
import '../scenario/scenario.dart';
import '../webdriver/selenium_webdriver.dart';


class ScenarioHtml{
  static final DivElement workspace = querySelector(".TestWorkspace");
  static void runScenario(String content){
    print(scenarioLineCommand.parse("I wait 3 secnds"));

    try{
      /*var driver = new WebDriver('http://localhost:4444/wd/hub');
      driver.newSession().then((WebDriverSession session){
        Scenario scenario = new Scenario()..session=session;
        var user = scenario.as("user");
        
        user.steps = scenarioParser.parse(content);
        scenario.start();
      });*/
    } catch(e){
      print(e);
    }
  }
}