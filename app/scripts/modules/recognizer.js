(function() {
  'use strict';
  var Recognizer;

  Recognizer = (function() {
    var recognize;

    function Recognizer() {}

    recognize = function() {
      return console.log('zavolal metodu z recognizera');
    };

    return Recognizer;

  })();

}).call(this);
