(function() {
  'use strict';
  var SaveOptions;

  SaveOptions = function() {
    return console.log('Settings saved.');
  };

  $('#save-options').click(function() {
    return new SaveOptions();
  });

}).call(this);
