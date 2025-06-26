
import 'icon_utils.dart';

const String jsHandleSignature = '''
  function insertSignature(signature, allowCollapsed) {
    const signatureNode = document.querySelector('div#editor div.tmail-signature');
    if (allowCollapsed) {
      if (signatureNode) {
        const currentSignatureContent = document.querySelector('div#editor div.tmail-signature div.tmail-signature-content');
        const currentSignatureButton = document.querySelector('div#editor div.tmail-signature button.tmail-signature-button');
      
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
      
        const nodeEditor = document.querySelector('div#editor');
        if (nodeEditor) {
          const headerQuotedMessage = document.querySelector('div#editor cite');
          const quotedMessage = document.querySelector('div#editor blockquote');
      
          if (headerQuotedMessage && headerQuotedMessage.parentNode === nodeEditor) {
            nodeEditor.insertBefore(signatureContainer, headerQuotedMessage);
          } else if (quotedMessage && quotedMessage.parentNode === nodeEditor) {
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
      
        const nodeEditor = document.querySelector('div#editor');
        if (nodeEditor) {
          const headerQuotedMessage = document.querySelector('div#editor cite');
          const quotedMessage = document.querySelector('div#editor blockquote');
      
          if (headerQuotedMessage && headerQuotedMessage.parentNode === nodeEditor) {
            nodeEditor.insertBefore(signatureContainer, headerQuotedMessage);
          } else if (quotedMessage && quotedMessage.parentNode === nodeEditor) {
            nodeEditor.insertBefore(signatureContainer, quotedMessage);
          } else {
            nodeEditor.appendChild(signatureContainer);
          }
        }
      }
    }
  }

  function removeSignature() {
    const nodeSignature = document.querySelector('div#editor div.tmail-signature');
    if (nodeSignature) {
      nodeSignature.remove();
    }
  }
  
  function replaceSignatureContent() {
    const nodeSignature = document.querySelector('div#editor div.tmail-signature');
    const signatureContent = document.querySelector('div#editor div.tmail-signature div.tmail-signature-content');
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
    const nodeSignature = document.querySelector('div#editor div.tmail-signature');
    if (nodeSignature) {
      return nodeSignature.innerHTML;
    } else {
      return '';
    }
  }
  
  function handleOnClickSignature() {
    const contentElement = document.querySelector('div#editor div.tmail-signature div.tmail-signature-content');
    const buttonElement = document.querySelector('div#editor div.tmail-signature button.tmail-signature-button');
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

const String jsContentSizeChangeListener = '''
  const bodyResizeObserver = new ResizeObserver(entries => {
    window.flutter_inappwebview.callHandler('ContentSizeChangedEventListener', '');
  })
    
  bodyResizeObserver.observe(document.body)
''';


const String jsHandleLazyLoadingBackgroundImage = '''
  const lazyImages = document.querySelectorAll('[lazy]');
  const lazyImageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const lazyImage = entry.target;
        const src = lazyImage.dataset.src;
        lazyImage.tagName.toLowerCase() === 'img'
          ? lazyImage.src = src
          : lazyImage.style.backgroundImage = "url(\'" + src + "\')";
        lazyImage.removeAttribute('lazy');
        observer.unobserve(lazyImage);
      }
    });
  });
  
  lazyImages.forEach((lazyImage) => {
    lazyImageObserver.observe(lazyImage);
  });
''';

const String jsHandleTextFormatting= '''
  function observeTextFormatting(editorElement, onFormatChange) {
    let lastFormat = {};
  
    function detectFormatting() {
      const selection = window.getSelection();
      let node = selection.rangeCount > 0 ? selection.getRangeAt(0).startContainer : null;
  
      if (!node) return;
  
      if (node.nodeType === Node.TEXT_NODE) {
        node = node.parentNode;
      }
  
      let format = {
        bold: false,
        italic: false,
        underline: false,
        strikeThrough: false,
      };
  
      let current = node;
  
      while (current && current.nodeType === 1) {
        const tag = current.tagName?.toLowerCase?.() || "";
        const style = current.style || {};
        const computed = window.getComputedStyle(current);
  
        // Tag-based checks
        if (tag === 'b' || tag === 'strong') format.bold = true;
        if (tag === 'i' || tag === 'em') format.italic = true;
        if (tag === 'u') format.underline = true;
        if (['s', 'strike', 'del'].includes(tag)) format.strikeThrough = true;
  
        // Inline style checks
        if (style.fontWeight === 'bold' || style.fontWeight === '700') format.bold = true;
        if (style.fontStyle === 'italic') format.italic = true;
        if (style.textDecoration?.includes('underline')) format.underline = true;
        if (style.textDecoration?.includes('line-through')) format.strikeThrough = true;
  
        // Computed style checks
        if (computed.fontWeight === 'bold' || parseInt(computed.fontWeight) >= 600) format.bold = true;
        if (computed.fontStyle === 'italic') format.italic = true;
        if (computed.textDecorationLine?.includes('underline')) format.underline = true;
        if (computed.textDecorationLine?.includes('line-through')) format.strikeThrough = true;
  
        current = current.parentNode;
      }
  
      const formatChanged = (
        format.bold !== lastFormat.bold ||
        format.italic !== lastFormat.italic ||
        format.underline !== lastFormat.underline ||
        format.strikeThrough !== lastFormat.strikeThrough
      );
  
      if (formatChanged) {
        lastFormat = format;
        onFormatChange(format);
      }
    }
  
    const observer = new MutationObserver(() => {
      detectFormatting();
    });
  
    observer.observe(editorElement, {
      childList: true,
      characterData: true,
      attributes: true,
      subtree: true,
    });
  
    document.addEventListener('selectionchange', () => {
      if (editorElement.contains(document.activeElement)) {
        detectFormatting();
      }
    });
  }
''';