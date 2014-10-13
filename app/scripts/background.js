(function() {
  'use strict';
  var active, update_icon;

  active = false;

  update_icon = function() {
    var icon_name;
    active = !active;
    console.log("aa");
    if (active) {
      icon_name = 'active';
    } else {
      icon_name = 'inactive';
    }
    return chrome.browserAction.setIcon({
      path: '../images/icon_' + icon_name + '.png'
    });
  };

  chrome.browserAction.onClicked.addListener(update_icon);

  update_icon();

}).call(this);
