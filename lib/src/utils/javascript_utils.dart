
const String jsHandleSignature = '''
  function insertSignature(signature) {
    const nodeSignature = document.getElementsByClassName('tmail-signature');
    if (nodeSignature.length <= 0) {
      const nodeEditor = document.getElementById('editor');
      
      const divSignature = document.createElement('div');
      divSignature.setAttribute('class', 'tmail-signature');
      divSignature.innerHTML = signature;
      
      const listHeaderQuotedMessage = nodeEditor.querySelectorAll('cite');
      const listQuotedMessage = nodeEditor.querySelectorAll('blockquote');
      
      if (listHeaderQuotedMessage.length > 0) {
        nodeEditor.insertBefore(divSignature, listHeaderQuotedMessage[0]);
      } else if (listQuotedMessage.length > 0) {
        nodeEditor.insertBefore(divSignature, listQuotedMessage[0]);
      } else {
        nodeEditor.appendChild(divSignature);
      }
    } else {
      nodeSignature[0].innerHTML = signature;
    }
  }

  function removeSignature() {
    const nodeSignature = document.getElementsByClassName('tmail-signature');
    if (nodeSignature.length > 0) {
      nodeSignature[0].remove();
    }
  }
  
''';

const String jsFindingInnerHtmlTags = '''
  function whichTag(tagName) {
    var sel, containerNode;
    var tagFound = false;

    tagName = tagName.toUpperCase();

    if (window.getSelection) {
        sel = window.getSelection();
        if (sel.rangeCount > 0) {
            containerNode = sel.getRangeAt(0).commonAncestorContainer;
        }
    } else if ((sel = document.selection) && sel.type != "Control") {
        containerNode = sel.createRange().parentElement();
    }

    while (containerNode) {
        if (containerNode.nodeType == 1 && containerNode.tagName == tagName) {
            tagFound = true;
            containerNode = null;
        } else {
            containerNode = containerNode.parentNode;
        }
    }

    return tagFound;
  }
  
''';