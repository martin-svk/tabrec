// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  this.Constants = (function() {
    var CURRENT_MULTI_ACTIVATE_VERSION, DEBUG_MODE, USAGE_LOGGING;

    function Constants() {}

    DEBUG_MODE = false;

    USAGE_LOGGING = true;

    CURRENT_MULTI_ACTIVATE_VERSION = 'V4';

    Constants.is_debug_mode = function() {
      return DEBUG_MODE;
    };

    Constants.usage_logging_on = function() {
      return USAGE_LOGGING;
    };

    Constants.get_api_url = function() {
      if (DEBUG_MODE) {
        return 'http://localhost:9292';
      } else {
        return 'http://tabber.fiit.stuba.sk:9292';
      }
    };

    Constants.get_batch_size = function() {
      if (DEBUG_MODE) {
        return 5;
      } else {
        return 50;
      }
    };

    Constants.get_max_running_average_bucket_size = function() {
      return 100;
    };

    Constants.get_rec_timeout = function() {
      if (DEBUG_MODE) {
        return 30000;
      } else {
        return 3 * 60000;
      }
    };

    Constants.get_current_activate_pattern_version = function() {
      return CURRENT_MULTI_ACTIVATE_VERSION;
    };

    return Constants;

  })();

}).call(this);
