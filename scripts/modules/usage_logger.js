// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  this.UsageLogger = (function() {
    var cache_usage_log, get_current_ts, get_domain, post_usage_logs, tab_activated, tab_attached, tab_created, tab_detached, tab_moved, tab_removed, tab_updated, _bsize, _cache, _conn, _dbg_mode, _last_post_time, _parser, _sha1, _sid, _uid;

    _bsize = Constants.get_batch_size();

    _dbg_mode = Constants.is_debug_mode();

    _parser = document.createElement('a');

    _conn = new Connection();

    _sha1 = new Hashes.SHA1();

    _uid = null;

    _sid = null;

    function UsageLogger(user_id, session_id) {
      _uid = user_id;
      _sid = session_id;
    }

    UsageLogger.prototype.start = function() {
      if (_dbg_mode) {
        console.log("Usage logger has started!");
      }
      chrome.tabs.onCreated.addListener(tab_created);
      chrome.tabs.onRemoved.addListener(tab_removed);
      chrome.tabs.onActivated.addListener(tab_activated);
      chrome.tabs.onMoved.addListener(tab_moved);
      chrome.tabs.onAttached.addListener(tab_attached);
      chrome.tabs.onDetached.addListener(tab_detached);
      return chrome.tabs.onUpdated.addListener(tab_updated);
    };

    _cache = [];

    _last_post_time = new Date().getTime();

    cache_usage_log = function(log) {
      if (_dbg_mode) {
        console.log("Caching usage log: User id: " + log.user_id + ", Tab id: " + log.tab_id + ", Event: " + log.event + ", Time: " + log.timestamp);
      }
      _cache.push(log);
      if ((_cache.length >= _bsize) || (get_current_ts() - _last_post_time > (2 * 60 * 1000))) {
        return post_usage_logs();
      }
    };

    post_usage_logs = function() {
      _conn.post_usage_logs(_cache.slice(0));
      _cache.length = 0;
      return _last_post_time = get_current_ts();
    };

    get_current_ts = function() {
      return new Date().getTime();
    };

    get_domain = function(subdomain) {
      var array, top_level_domain;
      array = subdomain.split('.');
      top_level_domain = array.pop();
      return "" + (array.pop()) + "." + top_level_domain;
    };

    tab_created = function(tab) {
      var _domain, _path, _subdomain;
      _parser.href = tab.url;
      _subdomain = _parser.hostname;
      _domain = get_domain(_subdomain);
      _path = _parser.pathname;
      if (_dbg_mode) {
        console.log("Subdomain: " + _subdomain + " domain: " + _domain + " path: " + _path + " url: " + _parser.href);
      }
      return cache_usage_log({
        user_id: _uid,
        session_id: _sid,
        timestamp: get_current_ts(),
        event: 'TAB_CREATED',
        window_id: tab.windowId,
        tab_id: tab.id,
        url: _sha1.hex(_parser.href),
        domain: _sha1.hex(_domain),
        subdomain: _sha1.hex(_subdomain),
        path: _sha1.hex(_path)
      });
    };

    tab_removed = function(tab_id, remove_info) {
      return cache_usage_log({
        user_id: _uid,
        session_id: _sid,
        timestamp: get_current_ts(),
        event: 'TAB_REMOVED',
        window_id: remove_info.windowId,
        tab_id: tab_id
      });
    };

    tab_activated = function(active_info) {
      return chrome.tabs.get(active_info.tabId, function(tab) {
        return cache_usage_log({
          user_id: _uid,
          session_id: _sid,
          timestamp: get_current_ts(),
          event: 'TAB_ACTIVATED',
          window_id: active_info.windowId,
          tab_id: active_info.tabId
        });
      });
    };

    tab_moved = function(tab_id, move_info) {
      return cache_usage_log({
        user_id: _uid,
        session_id: _sid,
        timestamp: get_current_ts(),
        event: 'TAB_MOVED',
        window_id: move_info.windowId,
        tab_id: tab_id,
        index_from: move_info.fromIndex,
        index_to: move_info.toIndex
      });
    };

    tab_attached = function(tab_id, attach_info) {
      return cache_usage_log({
        user_id: _uid,
        session_id: _sid,
        timestamp: get_current_ts(),
        event: 'TAB_ATTACHED',
        window_id: attach_info.newWindowId,
        tab_id: tab_id,
        index_to: attach_info.newPosition
      });
    };

    tab_detached = function(tab_id, detach_info) {
      return cache_usage_log({
        user_id: _uid,
        session_id: _sid,
        timestamp: get_current_ts(),
        event: 'TAB_DETACHED',
        window_id: detach_info.oldWindowId,
        tab_id: tab_id,
        index_from: detach_info.oldPosition
      });
    };

    tab_updated = function(tab_id, change_info, tab) {
      var _domain, _path, _subdomain;
      if (change_info.status === 'complete') {
        _parser.href = tab.url;
        _subdomain = _parser.hostname;
        _domain = get_domain(_subdomain);
        _path = _parser.pathname;
        if (_dbg_mode) {
          console.log("Subdomain: " + _subdomain + " domain: " + _domain + " path: " + _path + " url: " + _parser.href);
        }
        return cache_usage_log({
          user_id: _uid,
          session_id: _sid,
          timestamp: get_current_ts(),
          event: 'TAB_UPDATED',
          window_id: tab.windowId,
          tab_id: tab.id,
          url: _sha1.hex(_parser.href),
          domain: _sha1.hex(_domain),
          subdomain: _sha1.hex(_subdomain),
          path: _sha1.hex(_path)
        });
      }
    };

    return UsageLogger;

  })();

}).call(this);
