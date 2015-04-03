// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  this.Executor = (function() {
    var handle_multi_activate_pattern, revert_multi_activate_pattern, sort_tabs_by_domains, _dbg_mode, _tabs_backup;

    _dbg_mode = null;

    _tabs_backup = [];

    function Executor() {
      _dbg_mode = Constants.is_debug_mode();
    }

    Executor.prototype.execute = function(pattern) {
      if (_dbg_mode) {
        console.log("Executing action for: " + pattern);
      }
      if (pattern === 'MULTI_ACTIVATE_V2') {
        return handle_multi_activate_pattern();
      }
    };

    Executor.prototype.revert = function(pattern) {
      if (_dbg_mode) {
        console.log("Reverting action for: " + pattern);
      }
      if (pattern === 'MULTI_ACTIVATE_V2') {
        return revert_multi_activate_pattern();
      }
    };

    handle_multi_activate_pattern = function() {
      return chrome.tabs.query({
        windowId: chrome.windows.WINDOW_ID_CURRENT
      }, sort_tabs_by_domains);
    };

    revert_multi_activate_pattern = function() {
      var ids;
      ids = _tabs_backup.map(function(tab) {
        return tab.id;
      });
      return chrome.tabs.move(ids, {
        index: 0
      });
    };

    sort_tabs_by_domains = function(tabs) {
      var ids, tab, _i, _len, _tabs_ordered;
      _tabs_ordered = [];
      for (_i = 0, _len = tabs.length; _i < _len; _i++) {
        tab = tabs[_i];
        _tabs_ordered.push({
          id: tab.id,
          domain: new URL(tab.url).hostname
        });
        _tabs_backup.push({
          id: tab.id
        });
      }
      _tabs_ordered.sort(function(a, b) {
        return a.domain.localeCompare(b.domain);
      });
      ids = _tabs_ordered.map(function(tab) {
        return tab.id;
      });
      return chrome.tabs.move(ids, {
        index: 0
      });
    };

    return Executor;

  })();

}).call(this);
