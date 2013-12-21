
import 'dart:html';
  
  Object saveSelection(containerEl) {
    var range = window.getSelection().getRangeAt(0);
    var preSelectionRange = range.cloneRange();
    preSelectionRange.selectNodeContents(containerEl);
    preSelectionRange.setEnd(range.startContainer, range.startOffset);
    var start = preSelectionRange.toString().length;

    return {
      "start": start,
      "end": start + range.toString().length
    };
  }

  void restoreSelection(containerEl, savedSel) {
    var charIndex = 0, range = new Range();
    range.setStart(containerEl, 0);
    range.collapse(true);
    var nodeStack = [containerEl], foundStart = false, stop = false;
    Node node;
    while (!stop && !nodeStack.isEmpty) {
      node = nodeStack.removeLast();
      if (node.nodeType == Node.TEXT_NODE) {
        var nextCharIndex = charIndex + node.text.length;
        print(nextCharIndex);
        if (!foundStart && savedSel["start"] >= charIndex && savedSel["start"] <= nextCharIndex) {
          range.setStart(node, savedSel["start"] - charIndex);
          foundStart = true;
        }
        if (foundStart && savedSel["end"] >= charIndex && savedSel["end"] <= nextCharIndex) {
          range.setEnd(node, savedSel["end"] - charIndex);
          stop = true;
        }
        charIndex = nextCharIndex;
      } else {
        var i = node.nodes.length;
        while (i-- > 0) {
          nodeStack.add(node.nodes[i]);
        }
      }
    }

    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
  }