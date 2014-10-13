(function() {
  'use strict';
  var active, update_icon;

  active = true;

  update_icon = function() {
    var icon_name;
    if (active) {
      icon_name = 'active';
    } else {
      icon_name = 'inactive';
    }
    chrome.browserAction.setIcon({
      path: '../images/icon_' + icon_name + '.png'
    });
    return active = !active;
  };

  chrome.browserAction.onClicked.addListener(update_icon);

  update_icon();

}).call(this);
