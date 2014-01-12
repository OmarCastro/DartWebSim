ace.define('ace/mode/websim', function(require, exports, module) {

var oop = require("ace/lib/oop");
var TextMode = require("ace/mode/text").Mode;
var Tokenizer = require("ace/tokenizer").Tokenizer;
var WebSimHighlightRules = require("ace/mode/websim_highlight_rules").WebSimHighlightRules;

var Mode = function() {
    this.HighlightRules = WebSimHighlightRules;
};
oop.inherits(Mode, TextMode);
exports.Mode = Mode;
});



ace.define('ace/mode/websim_highlight_rules', function(require, exports, module) {

var oop = require("ace/lib/oop");
var lang = require("ace/lib/lang");

var TextHighlightRules = require("ace/mode/text_highlight_rules").TextHighlightRules;


var supportType = exports.supportType = "I go to page|I get element of|I wait";

var WebSimHighlightRules = function() {

var keywordMapper = this.createKeywordMapper({
        "support.type": supportType
    }, "text", false);
    

    var urlregex = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/;
    
var StartToken_I = {
                token: "keyword",
                regex: "^I",
                next: "user",
                caseInsensitive: false
            };
            
var StartToken_It = {
                token: "keyword",
                regex: "^It",
                next: "condition",
                caseInsensitive: false
            };

   this.$rules = {
        "start" : [StartToken_It,StartToken_I],
        "user" : [{
            token: "keyword",
            regex: "go to( page)?",
            next: "url"
            },{
            token: "keyword",
            regex: "get element of",
            next: "elget"
            },{
            token: ["keyword","keyword","keyword","string"],
            regex: /(get link with )(exact )?(text )(.+)/,
            next: "start"
            },{
            token: ["keyword", "string"],
            regex: "(write\\ )(.+)",
            next: "start"
            },{
            token: ["keyword", "constant.numeric","text", "string","string"],
            regex: "(wait)(\\ [0-9]+)(\\ )(milli)?(seconds)",
            next: "start"
            },{
            token: "keyword",
            regex: "click it",
            next:  "start"
            }

        ],
        "condition":[{
            token: "keyword",
            regex: /is visible/,
            next: "start"
        }],
        
        "url" : [{
            token: "string",
            regex: urlregex,
            next: "start"
        }],
        
        "elget" : [{
            token: ["variable.parameter","variable.parameter","string"],
            regex: /(Id)|(name)(\ [_a-z0-9-]*)/,
            next: "start",
            caseInsensitive: true
        }, {
            token: "variable.parameter",
            regex: /css/,
            next: "css",
            caseInsensitive: true
        }, {
            token: "variable.parameter",
            regex: /xpath/,
            next: "xpath",
            caseInsensitive: true
        }],
        "xpath": [StartToken_It,StartToken_I,
        {
            token: "support.constant",
            regex: /[\/()\[\]]/
        },{
            token: ["support.function","support.constant"],
            regex: /([a-z0-9-_]+)(\()/
        }, {
            token: "variable",
            regex: "@[a-z0-9-_]+"
        }, {
            token: "string",
            regex: /\"[^\"]+\"/
        },{
            token: "support.type",
            regex: "[a-z0-9-_]+",
        },{
            caseInsensitive: true,
        }],
        "css": [StartToken_It,StartToken_I,
        {
            token: "keyword",
            regex: "#[a-z0-9-_]+",
        }, {
            token: "variable",
            regex: "\\.[a-z0-9-_]+"
        }, {
            token: "string",
            regex: ":[a-z0-9-_]+"
        }, {
            token: "constant",
            regex: "[a-z0-9-_]+"
        },{
            caseInsensitive: true,
        }]
    };
    
    this.normalizeRules();
    
};

oop.inherits(WebSimHighlightRules, TextHighlightRules);

exports.WebSimHighlightRules = WebSimHighlightRules;
});

