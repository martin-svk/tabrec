// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  this.Recognizer = (function() {
    var get_current_ts, get_running_average, handle_running_average, has_suffix, in_threshold, inside_running_average, is_bottom_outlier, is_upper_outlier, not_inside_timeout, record_event, reset_all_pattern_states, some_pattern_occured, tab_activated, tab_attached, tab_created, tab_detached, tab_moved, tab_removed, tab_updated, update_current_sequences, _accuracy, _dbg_mode, _last_event_time, _last_pattern_time, _max_running_average_bucket_size, _max_running_average_event_gap, _min_running_average_event_gap, _notifier, _pattern_recognizers, _rec_timeout, _running_average_bucket, _running_average_gap_inclusion_threshold;

    _dbg_mode = Constants.is_debug_mode();

    _rec_timeout = Constants.get_rec_timeout();

    _max_running_average_bucket_size = Constants.get_max_running_average_bucket_size();

    _running_average_gap_inclusion_threshold = Constants.get_running_average_gap_inclusion_threshold();

    _max_running_average_event_gap = Constants.get_max_running_average_event_gap();

    _min_running_average_event_gap = Constants.get_min_running_average_event_gap();

    _accuracy = 100;

    _notifier = null;

    _pattern_recognizers = [];

    function Recognizer(user_id, session_id) {
      _notifier = new Notifier(user_id);
      _pattern_recognizers.push(new MultiActivatePattern(), new ComparePattern());
    }

    Recognizer.prototype.start = function() {
      if (_dbg_mode) {
        console.log("Pattern recognizer has started!");
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

    _last_pattern_time = null;

    _running_average_bucket = [];

    tab_activated = function(active_info) {
      var event_data, tab_id, time_occured;
      time_occured = get_current_ts();
      tab_id = active_info.tabId;
      if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
        _last_event_time = time_occured;
        return;
      }
      handle_running_average(time_occured);
      event_data = {
        tab_id: tab_id,
        tab_index: null
      };
      chrome.tabs.get(tab_id, function(tab) {
        event_data.tab_index = tab.index;
        return record_event('TAB_ACTIVATED', time_occured, event_data);
      });
      return _last_event_time = time_occured;
    };

    tab_created = function(tab) {
      var time_occured;
      time_occured = get_current_ts();
      if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
        _last_event_time = time_occured;
        return;
      }
      handle_running_average(time_occured);
      record_event('TAB_CREATED', time_occured, {});
      return _last_event_time = time_occured;
    };

    tab_removed = function(tab_id, remove_info) {
      var time_occured;
      time_occured = get_current_ts();
      if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
        _last_event_time = time_occured;
        return;
      }
      handle_running_average(time_occured);
      record_event('TAB_REMOVED', time_occured, {});
      return _last_event_time = time_occured;
    };

    tab_moved = function(tab_id, move_info) {
      var time_occured;
      time_occured = get_current_ts();
      if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
        _last_event_time = time_occured;
        return;
      }
      handle_running_average(time_occured);
      record_event('TAB_MOVED', time_occured, {});
      return _last_event_time = time_occured;
    };

    tab_attached = function(tab_id, attach_info) {
      var time_occured;
      time_occured = get_current_ts();
      if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
        _last_event_time = time_occured;
        return;
      }
      handle_running_average(time_occured);
      record_event('TAB_ATTACHED', time_occured, {});
      return _last_event_time = time_occured;
    };

    tab_detached = function(tab_id, detach_info) {
      var time_occured;
      time_occured = get_current_ts();
      if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
        _last_event_time = time_occured;
        return;
      }
      handle_running_average(time_occured);
      record_event('TAB_DETACHED', time_occured, {});
      return _last_event_time = time_occured;
    };

    tab_updated = function(tab_id, change_info, tab) {
      var event_data, time_occured;
      if (change_info.status === 'complete') {
        time_occured = get_current_ts();
        if (is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)) {
          _last_event_time = time_occured;
          return;
        }
        handle_running_average(time_occured);
        event_data = {
          url: tab.url
        };
        record_event('TAB_UPDATED', time_occured, event_data);
        return _last_event_time = time_occured;
      }
    };

    record_event = function(event_name, time_occured, event_data) {
      var pattern_name;
      if (inside_running_average(time_occured)) {
        update_current_sequences(event_name, event_data);
        if ((pattern_name = some_pattern_occured()) && not_inside_timeout(get_current_ts())) {
          _notifier.show_pattern(pattern_name);
          _last_pattern_time = get_current_ts();
          return reset_all_pattern_states();
        }
      } else {
        return reset_all_pattern_states();
      }
    };

    some_pattern_occured = function() {
      var pattern, _i, _len;
      for (_i = 0, _len = _pattern_recognizers.length; _i < _len; _i++) {
        pattern = _pattern_recognizers[_i];
        if (has_suffix(pattern.current_sequence(), pattern.pattern_sequence()) && pattern.specific_conditions_satisfied()) {
          return pattern.name();
        }
      }
      return false;
    };

    handle_running_average = function(new_event_ts) {
      var last_gap;
      if (_last_event_time === null) {
        return;
      }
      last_gap = parseInt((new_event_ts - _last_event_time) / _accuracy, 10);
      if (_dbg_mode) {
        console.log("Current last gap: " + (last_gap / 10) + " seconds");
      }
      if (_running_average_bucket.length < _max_running_average_bucket_size) {
        return _running_average_bucket.push(last_gap);
      } else {
        _running_average_bucket.shift();
        return _running_average_bucket.push(last_gap);
      }
    };

    get_running_average = function() {
      var avg, i, sum;
      i = _running_average_bucket.length;
      sum = 0;
      while (i--) {
        sum += _running_average_bucket[i];
      }
      avg = parseInt((sum / _running_average_bucket.length) * _accuracy, 10);
      if (_dbg_mode) {
        console.log("Current running average: " + avg + " micro seconds.");
      }
      return avg;
    };

    update_current_sequences = function(event_name, event_data) {
      var pattern, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = _pattern_recognizers.length; _i < _len; _i++) {
        pattern = _pattern_recognizers[_i];
        _results.push(pattern.register_event(event_name, event_data));
      }
      return _results;
    };

    reset_all_pattern_states = function() {
      var pattern, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = _pattern_recognizers.length; _i < _len; _i++) {
        pattern = _pattern_recognizers[_i];
        _results.push(pattern.reset_states());
      }
      return _results;
    };

    inside_running_average = function(time_occured) {
      return _last_event_time === null || in_threshold(time_occured - _last_event_time, get_running_average());
    };

    not_inside_timeout = function(current_time) {
      return _last_pattern_time === null || (current_time - _last_pattern_time) > _rec_timeout;
    };

    is_upper_outlier = function(new_event_ts) {
      return _last_event_time !== null && (new_event_ts - _last_event_time) > _max_running_average_event_gap;
    };

    is_bottom_outlier = function(new_event_ts) {
      return _last_event_time !== null && (new_event_ts - _last_event_time) < _min_running_average_event_gap;
    };

    in_threshold = function(time1, time2) {
      return (time1 < (time2 + time2 * _running_average_gap_inclusion_threshold)) || (time1 < (time2 - time2 * _running_average_gap_inclusion_threshold));
    };

    get_current_ts = function() {
      return new Date().getTime();
    };

    has_suffix = function(str, suffix) {
      return str.indexOf(suffix, str.length - suffix.length) !== -1;
    };

    return Recognizer;

  })();

}).call(this);
