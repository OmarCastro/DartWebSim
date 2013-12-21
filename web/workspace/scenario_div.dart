import 'dart:html';
import 'scenario_parser.dart';
import '../scenario/scenario.dart';
import '../webdriver/selenium_webdriver.dart';
import 'ranges.dart';


class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(node) {}
}

class ScenarioHtml{
  static final Element scenarioFragment = new Element.html(
      """<div class="scenario">
        <div class="comment"></div>
        <div class="steps">
          <div class="run">run</div>
          <div class="add-step"></div>
          <div class="content">
            <div>I go to page http://www.google.com</div>
            <div>I get element of name q</div>
            <div>I write google</div>
            <div></div><div></div><div></div>
          </div>
        </div>
      </div>
      """);
  
  
  static final DivElement workspace = querySelector(".TestWorkspace");
  
  
  static updateAllContents(){
    querySelectorAll(".content div").forEach((Element elem){
      if(elem.text.isEmpty){
        elem.parent.children.remove(elem);
      } else {
        try{
          String html = HLCommand.parse(elem.text);
          elem.setInnerHtml(html,treeSanitizer: new NullTreeSanitizer());
        } catch(e){
          print(e);
          elem.setInnerHtml("<span class=\"syntax-error\">${elem.text}</span>");
        }
      }
    });
  }
  
  static void addScenario(){
    DivElement elem = scenarioFragment.clone(true);
    
    elem.querySelector(".comment").contentEditable = "true";
    elem.querySelector(".content")
      ..contentEditable = "true"
      ..onInput.listen((Event ev){
      Selection sel = window.getSelection();
      Node node = sel.anchorNode,initnode = node;

      while(!(node is DivElement)){
        node = node.parentNode;
      }
      if(!node.text.isEmpty && !(node as DivElement).classes.contains("content")){
        var ranges = saveSelection(node);
        DivElement elem = node;

        try{
          print(node.text);
          String html = HLParser.parse(node.text);
          elem.title = null;
          elem.classes.remove("syntax-error");
          elem.setInnerHtml(html);
        } catch(e){
          String error = e.toString();
          elem.title = error;
          elem.classes.add("syntax-error");
          elem.innerHtml = elem.text;
        }
        
        restoreSelection(node,ranges);
      }
    });
    
    workspace.append(elem);

    
    DivElement addbutton = elem.querySelector(".add-step");
    addbutton.onClick.listen((MouseEvent ev){
      Element element = ev.target;
      addScenarioStep(element.parent);
    });
    DivElement runbutton = elem.querySelector(".run");
    runbutton.onClick.listen((MouseEvent ev){
      Element element = ev.target;
      runScenario(element.parent);
    });
    updateAllContents();
    
  }
  
  static void addScenarioStep(DivElement stepsNode){
    Element elem = stepsNode.append(new ParagraphElement());
    elem.focus();
  }
  
  static void runScenario(DivElement stepsNode){
    DivElement steps = stepsNode.querySelector(".content");
    List<String> content = new List<String>();
    steps.children.forEach((Element elem){
      if(elem.text.isEmpty){
        steps.children.remove(elem);
      } else {
        content.add(elem.text);
      }
    });
    try{
      var commands = scenarioText.parse(content.join("\n"));
      //window.console.log(commands);
      var driver = new WebDriver('http://localhost:4444/wd/hub');
      driver.newSession().then((WebDriverSession session){
        Scenario scenario = new Scenario()..session=session;
        var user = scenario.as("user");
        user.steps = commands;
      scenario.start();
      });
    } catch(e){
      print(e);
    }
  }
}