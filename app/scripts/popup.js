(function() {
  'use strict';
  var active, updateIcon;

  active = true;

  updateIcon = function(val) {
    var iconName;
    if (val) {
      iconName = 'active';
    } else {
      iconName = 'inactive';
    }
    active = val;
    return chrome.browserAction.setIcon({
      path: '../images/icon_' + iconName + '.png'
    });
  };

  $('#tabrec-status').change(function() {
    return updateIcon($(this).prop('checked'));
  });

  $(document).ready(function() {
    return $('#tabrec-status').prop('checked', active);
  });

}).call(this);
