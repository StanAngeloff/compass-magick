#!/usr/bin/env phantomjs
var width   = parseInt(phantom.args[0], 10),
    height  = parseInt(phantom.args[1], 10),
    padding = Math.max(width, height),
    page = require('webpage').create(),
    head, body, i, styles, j, length, instruction;
if (isNaN(width) || isNaN(height) || phantom.args.length < 4) {
  console.error('Usage: magick.js width height styles [styles […]] filename');
  phantom.exit();
} else {
  head = []; body = [];
  for (i = 2; i < phantom.args.length - 1; i ++) {
    styles = phantom.args[i].split(';');
    for (j = 0, length = styles.length; j < length; j ++) {
      instruction = styles[j].replace(/^\s+|\s+$/g, '');
      if (instruction.indexOf(':') > 0) {
        styles.push('-webkit-' + instruction);
      }
    }
    head.push('#element-' + i + ' { ' +
      'width:  ' + width  + 'px; ' +
      'height: ' + height + 'px; ' +
      'box-sizing: border-box; ' +
      '-webkit-box-sizing: border-box; ' +
      styles.join('; ') + '; ' +
    '}');
    body.push('<div id="element-' + i + '"></div>');
  }
  try {
    page.viewportSize = {
      width:  width  + padding * 2,
      height: height + padding * 2
    };
    page.content =
      '<html>' +
        '<head>' +
        '<style>' +
          head.join('\n') +
        '</style>' +
        '</head>' +
        '<body style="background: transparent; margin: ' + padding + 'px ' + padding + 'px; padding: 0;">' +
          body.join('\n') +
        '</body>' +
      '</html>';
    page.render(phantom.args[phantom.args.length - 1]);
    phantom.exit();
  } catch (e) {
    phantom.exit();
    throw e;
  }
}