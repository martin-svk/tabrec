// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  this.UUID = (function() {
    var generate_uuid;

    function UUID() {}

    UUID.prototype.ensure_in_storage = function() {
      return chrome.storage.sync.get(['user_id'], function(result) {
        if (!result.user_id) {
          return chrome.storage.sync.set({
            'user_id': generate_uuid()
          });
        }
      });
    };

    generate_uuid = function() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r, v;
        r = Math.random() * 16 | 0;
        v = c === 'x' ? r : r & 0x3 | 0x8;
        return v.toString(16);
      });
    };

    return UUID;

  })();

}).call(this);
