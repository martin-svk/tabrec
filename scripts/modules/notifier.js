(function() {
  'use strict';
  var Notifier;

  Notifier = (function() {
    var notify;

    function Notifier() {}

    notify = function() {
      return console.log('Notifying...');
    };

    return Notifier;

  })();

}).call(this);
