
import 'package:enough_html_editor/src/utils/icon_utils.dart';

const String jsHandleSignature = '''
  function insertSignature(signature, allowCollapsed) {
    const signatureNode = document.querySelector('#editor > .tmail-signature');
    if (allowCollapsed) {
      if (signatureNode) {
        const currentSignatureContent = document.querySelector('#editor > .tmail-signature > .tmail-signature-content');
        const currentSignatureButton = document.querySelector('#editor > .tmail-signature > .tmail-signature-button');
      
        if (currentSignatureContent && currentSignatureButton) {
          currentSignatureContent.innerHTML = signature;
          currentSignatureButton.contentEditable = "false";
          currentSignatureButton.setAttribute('onclick', 'handleOnClickSignature()');
          if (currentSignatureContent.style.display === 'none') {
            currentSignatureButton.style.backgroundImage = `${IconUtils.chevronDownSVGIconUrlEncoded}`;
          } else {
            currentSignatureButton.style.backgroundImage = `${IconUtils.chevronUpSVGIconUrlEncoded}`;
          }
        } else {
          const signatureContainer = document.createElement('div');
          signatureContainer.setAttribute('class', 'tmail-signature');
      
          const signatureContent = document.createElement('div');
          signatureContent.setAttribute('class', 'tmail-signature-content');
          signatureContent.innerHTML = signature;
          signatureContent.style.display = 'none';
      
          const signatureButton = document.createElement('button');
          signatureButton.setAttribute('class', 'tmail-signature-button');
          signatureButton.textContent = 'Signature';
          signatureButton.contentEditable = "false";
          signatureButton.style.backgroundImage = `${IconUtils.chevronDownSVGIconUrlEncoded}`;
          signatureButton.setAttribute('onclick', 'handleOnClickSignature()');
      
          signatureContainer.appendChild(signatureButton);
          signatureContainer.appendChild(signatureContent);
      
          if (signatureNode.outerHTML) {
            signatureNode.outerHTML = signatureContainer.outerHTML;
          } else {
            signatureNode.parentNode.replaceChild(signatureContainer, signatureNode);
          }
        }
      } else {
        const signatureContainer = document.createElement('div');
        signatureContainer.setAttribute('class', 'tmail-signature');
      
        const signatureContent = document.createElement('div');
        signatureContent.setAttribute('class', 'tmail-signature-content');
        signatureContent.innerHTML = signature;
        signatureContent.style.display = 'none';
      
        const signatureButton = document.createElement('button');
        signatureButton.setAttribute('class', 'tmail-signature-button');
        signatureButton.textContent = 'Signature';
        signatureButton.contentEditable = "false";
        signatureButton.style.backgroundImage = `${IconUtils.chevronDownSVGIconUrlEncoded}`;
        signatureButton.setAttribute('onclick', 'handleOnClickSignature()');
      
        signatureContainer.appendChild(signatureButton);
        signatureContainer.appendChild(signatureContent);
      
        const nodeEditor = document.querySelector('#editor');
        if (nodeEditor) {
          const headerQuotedMessage = document.querySelector('#editor > cite');
          const quotedMessage = document.querySelector('#editor > blockquote');
      
          if (headerQuotedMessage) {
            nodeEditor.insertBefore(signatureContainer, headerQuotedMessage);
          } else if (quotedMessage) {
            nodeEditor.insertBefore(signatureContainer, quotedMessage);
          } else {
            nodeEditor.appendChild(signatureContainer);
          }
        }
      }
    } else {
      if (!signatureNode) {
        const signatureContainer = document.createElement('div');
        signatureContainer.setAttribute('class', 'tmail-signature');
        signatureContainer.innerHTML = signature;
        signatureContainer.style.display = 'block';
      
        const nodeEditor = document.querySelector('#editor');
        if (nodeEditor) {
          const headerQuotedMessage = document.querySelector('#editor > cite');
          const quotedMessage = document.querySelector('#editor > blockquote');
      
          if (headerQuotedMessage) {
            nodeEditor.insertBefore(signatureContainer, headerQuotedMessage);
          } else if (quotedMessage) {
            nodeEditor.insertBefore(signatureContainer, quotedMessage);
          } else {
            nodeEditor.appendChild(signatureContainer);
          }
        }
      }
    }
  }

  function removeSignature() {
    const nodeSignature = document.querySelector('#editor > .tmail-signature');
    if (nodeSignature) {
      nodeSignature.remove();
    }
  }
  
  function replaceSignatureContent() {
    const nodeSignature = document.querySelector('#editor > .tmail-signature');
    const signatureContent = document.querySelector('#editor > .tmail-signature > .tmail-signature-content');
    if (nodeSignature && signatureContent) {
      signatureContent.className = 'tmail-signature';
      signatureContent.style.display = 'block';
        
      if (nodeSignature.outerHTML) {
        nodeSignature.outerHTML = signatureContent.outerHTML;
      } else { 
        nodeSignature.parentNode.replaceChild(signatureContent, nodeSignature); 
      }
    }
  }
  
  function getSignatureContent() {
    const nodeSignature = document.querySelector('#editor > .tmail-signature');
    if (nodeSignature) {
      return nodeSignature.innerHTML;
    } else {
      return '';
    }
  }
  
  function handleOnClickSignature() {
    const contentElement = document.querySelector('#editor > .tmail-signature > .tmail-signature-content');
    const buttonElement = document.querySelector('#editor > .tmail-signature > .tmail-signature-button');
    if (contentElement && buttonElement) {
      if (contentElement.style.display === 'block') {
        contentElement.style.display = 'none';
        buttonElement.style.backgroundImage = `${IconUtils.chevronDownSVGIconUrlEncoded}`;
      } else {
        contentElement.style.display = 'block';
        buttonElement.style.backgroundImage = `${IconUtils.chevronUpSVGIconUrlEncoded}`;
      }
    }
    adjustEditorHeight();
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