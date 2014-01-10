ace.define('ace/snippets/websim', ['require', 'exports', 'module' ], function(require, exports, module) {


exports.snippetText = "snippet gtp\n\
	I go to page http://${1}\n\
snippet gei\n\
	I get element of Id ${1}\n\
snippet gec\n\
	I get element of CSS ${1}\n\
snippet gex\n\
	I get element of xpath ${1}\n\
snippet gen\n\
	I get element of name ${1}\n\
snippet wr\n\
	I write ${1}\n\
snippet ws\n\
	I wait ${1} seconds\n\
snippet wms\n\
	I wait ${1} milliseconds\n\
";
exports.scope = "websim";

});