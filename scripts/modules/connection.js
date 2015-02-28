// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  this.Connection = (function() {
    var get_collection, get_member, post_collection, post_member, _dbg;

    _dbg = false;

    function Connection(url, debug_mode) {
      this.url = url;
      this.debug_mode = debug_mode;
      _dbg = this.debug_mode;
    }

    Connection.prototype.get_user = function(id, callback) {
      return get_member(this.url, 'users', id, callback);
    };

    Connection.prototype.get_user_bstats = function(id, callback) {
      return get_member(this.url, 'stats/browsing', id, callback);
    };

    Connection.prototype.create_user = function(data) {
      return post_member(this.url, data, 'users');
    };

    Connection.prototype.post_usage_logs = function(data) {
      return post_collection(this.url, data, 'logs/usage');
    };

    get_member = function(url, resource, id, callback) {
      return $.ajax("" + url + "/" + resource + "/" + id, {
        type: 'GET',
        dataType: 'json',
        error: function(jqXHR, textStatus, errorThrown) {
          return callback(null);
        },
        success: function(data, textStatus, jqXHR) {
          return callback(data);
        }
      });
    };

    get_collection = function(url, resource) {
      return $.ajax("" + url + "/" + resource, {
        type: 'GET',
        dataType: 'json',
        error: function(jqXHR, textStatus, errorThrown) {
          return console.log("Error: " + textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          var event, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            event = data[_i];
            _results.push(console.log("" + event['name']));
          }
          return _results;
        }
      });
    };

    post_member = function(url, data, resource) {
      return $.ajax("" + url + "/" + resource, {
        type: 'POST',
        dataType: 'json',
        data: {
          user: data
        },
        success: function(data, textStatus, jqXHR) {
          if (_dbg) {
            return console.log("Status: " + textStatus);
          }
        }
      });
    };

    post_collection = function(url, data, resource) {
      return $.ajax("" + url + "/" + resource, {
        type: 'POST',
        dataType: 'json',
        data: {
          data: data
        },
        success: function(data, textStatus, jqXHR) {
          if (_dbg) {
            return console.log("Status: " + textStatus);
          }
        }
      });
    };

    return Connection;

  })();

}).call(this);
