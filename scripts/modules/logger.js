// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.Logger = (function() {
    var conn, current_state_is_pattern, dbg_mode, get_current_ts, notifier, process_event, sid, tab_activated, tab_attached, tab_created, tab_detached, tab_moved, tab_removed, tab_updated, uid, _activate_pattern, _current_sequence, _ignored_events, _last_event_time, _max_gap, _patterns;

    dbg_mode = Constants.is_debug_mode();

    conn = new Connection();

    notifier = new Notifier();

    uid = null;

    sid = null;

    function Logger(user_id, session_id) {
      uid = user_id;
      sid = session_id;
    }

    Logger.prototype.start = function() {
      if (dbg_mode) {
        console.log("Rec logger has started!");
      }
      chrome.tabs.onCreated.addListener(tab_created);
      chrome.tabs.onRemoved.addListener(tab_removed);
      chrome.tabs.onActivated.addListener(tab_activated);
      chrome.tabs.onMoved.addListener(tab_moved);
      chrome.tabs.onAttached.addListener(tab_attached);
      chrome.tabs.onDetached.addListener(tab_detached);
      return chrome.tabs.onUpdated.addListener(tab_updated);
    };

    _last_event_time = null;

    _max_gap = Constants.get_max_gap();

    _current_sequence = [];

    _activate_pattern = ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED'];

    _ignored_events = ['TAB_REMOVED'];

    _patterns = [_activate_pattern];

    tab_created = function(tab) {
      return process_event('TAB_CREATED', get_current_ts());
    };

    tab_removed = function(tab_id, remove_info) {
      return process_event('TAB_REMOVED', get_current_ts());
    };

    tab_activated = function(active_info) {
      return process_event('TAB_ACTIVATED', get_current_ts());
    };

    tab_moved = function(tab_id, move_info) {
      return process_event('TAB_MOVED', get_current_ts());
    };

    tab_attached = function(tab_id, attach_info) {
      return process_event('TAB_ATTACHED', get_current_ts());
    };

    tab_detached = function(tab_id, detach_info) {
      return process_event('TAB_DETACHED', get_current_ts());
    };

    tab_updated = function(tab_id, change_info, tab) {
      if (change_info.status === 'complete') {
        return process_event('TAB_UPDATED', get_current_ts());
      }
    };

    process_event = function(event_name, time_occured) {
      if (_last_event_time === null || (time_occured - _last_event_time) < _max_gap) {
        if (__indexOf.call(_ignored_events, event_name) < 0) {
          _current_sequence.push(event_name);
          if (current_state_is_pattern(_current_sequence)) {
            notifier.notify(_current_sequence);
            _current_sequence = [];
          }
        }
      } else {
        _current_sequence = [];
      }
      return _last_event_time = time_occured;
    };

    current_state_is_pattern = function(sequence) {
      var pattern, _i, _len;
      if (dbg_mode) {
        console.log("Current sequence: " + sequence);
      }
      for (_i = 0, _len = _patterns.length; _i < _len; _i++) {
        pattern = _patterns[_i];
        if (sequence.length === pattern.length && sequence.toString() === pattern.toString()) {
          return true;
        }
      }
      return false;
    };

    get_current_ts = function() {
      return new Date().getTime();
    };

    return Logger;

  })();

}).call(this);
