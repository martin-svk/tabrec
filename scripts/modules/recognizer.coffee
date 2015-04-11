'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to recognize patterns
# and use notifier to show notifications
# ======================================

class @Recognizer
  _dbg_mode = Constants.is_debug_mode()
  _rec_timeout = Constants.get_rec_timeout()
  _max_running_average_bucket_size = Constants.get_max_running_average_bucket_size()
  _accuracy = 100

  _notifier = null
  _multi_activate = null
  _patterns = []

  constructor: (user_id, session_id) ->
    _notifier = new Notifier(user_id)
    # Add pattern classes which will be recognized
    _multi_activate = new MultiActivate()
    _patterns.push(_multi_activate)

  # ===================================
  # Public methods
  # ===================================

  start: () ->
    console.log("Pattern recognizer has started!") if _dbg_mode
    chrome.tabs.onCreated.addListener(tab_created)
    chrome.tabs.onRemoved.addListener(tab_removed)
    chrome.tabs.onActivated.addListener(tab_activated)
    chrome.tabs.onMoved.addListener(tab_moved)
    chrome.tabs.onAttached.addListener(tab_attached)
    chrome.tabs.onDetached.addListener(tab_detached)
    chrome.tabs.onUpdated.addListener(tab_updated)

  # ===================================
  # Locals
  # ===================================

  _last_event_time = null
  _last_pattern_time = null

  _current_sequence = []
  _running_average_bucket = []

  # ===================================
  # Event handlers
  # ===================================

  # Activate event handling
  # ===================================

  tab_activated = (active_info) ->
    # Update running average
    time_occured = get_current_ts()
    handle_running_average(time_occured)

    tab_id = active_info.tabId

    chrome.tabs.get(tab_id, (tab) ->
      position = tab.index

      # Ask multi activate class if this event should be recorded
      if _multi_activate.should_record_activate(position, tab_id)
        record_event('TAB_ACTIVATED', time_occured)
    )

    # Updating last event time
    _last_event_time = time_occured

  # Generic event handling
  # ===================================

  tab_created = (tab) ->
    # Update running average
    time_occured = get_current_ts()
    handle_running_average(time_occured)

    record_event('TAB_CREATED', time_occured)

    # Updating last event time
    _last_event_time = time_occured

  tab_removed = (tab_id, remove_info) ->
    # Update running average
    time_occured = get_current_ts()
    handle_running_average(time_occured)

    record_event('TAB_REMOVED', time_occured)

    # Updating last event time
    _last_event_time = time_occured

  tab_moved = (tab_id, move_info) ->
    # Update running average
    time_occured = get_current_ts()
    handle_running_average(time_occured)

    record_event('TAB_MOVED', time_occured)

    # Updating last event time
    _last_event_time = time_occured

  tab_attached = (tab_id, attach_info) ->
    # Update running average
    time_occured = get_current_ts()
    handle_running_average(time_occured)

    record_event('TAB_ATTACHED', time_occured)

    # Updating last event time
    _last_event_time = time_occured

  tab_detached = (tab_id, detach_info) ->
    # Update running average
    time_occured = get_current_ts()
    handle_running_average(time_occured)

    record_event('TAB_DETACHED', time_occured)

    # Updating last event time
    _last_event_time = time_occured

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'
      # Update running average
      time_occured = get_current_ts()
      handle_running_average(time_occured)

      record_event('TAB_UPDATED', time_occured)

      # Updating last event time
      _last_event_time = time_occured

  # ===================================
  # Pattern recognizing
  # ===================================

  record_event = (event_name, time_occured) ->
    if inside_running_average(time_occured)
      _current_sequence.push(event_name)
      if (pattern_name = current_state_match_some_pattern(_current_sequence)) && not_inside_timeout(get_current_ts())
        _notifier.show_pattern(pattern_name)
        _last_pattern_time = get_current_ts()
        _current_sequence = []
    else
      # Outside running average gap
      _current_sequence = []

  # Will handle adding new timestamp to running average array or
  # replace oldest value when reaching maximum bucket size
  # ===================================

  handle_running_average = (new_event_ts) ->
    # Only work when we have first event
    return if _last_event_time == null

    last_gap = parseInt((new_event_ts - _last_event_time) / _accuracy, 10) # 0.1 seconds accuracy
    console.log("Current last gap: #{last_gap / 10} seconds") if _dbg_mode

    if _running_average_bucket.length < _max_running_average_bucket_size
      _running_average_bucket.push(last_gap)
    else
      _running_average_bucket.shift()
      _running_average_bucket.push(last_gap)

  # Will calculate and return current running average
  # ===================================

  get_running_average = () ->
    i = _running_average_bucket.length
    sum = 0
    while (i--)
      sum += _running_average_bucket[i]

    # Times _accuracy to make it micro seconds
    avg = parseInt((sum / _running_average_bucket.length) * _accuracy, 10)
    console.log("Current running average: #{avg} micro seconds.") if _dbg_mode

    return avg

  # ===================================
  # Helper functions
  # ===================================

  # Check if current state contains some patterns sequence suffix
  # ===================================

  current_state_match_some_pattern = (sequence) ->
    console.log("Current sequence: #{sequence}") if _dbg_mode
    for pattern in _patterns
      if has_suffix(sequence.toString(), pattern.sequence().toString())
        return pattern.name()
    return false

  # Check if we are inside thresholed gap timeout
  # ===================================

  inside_running_average = (time_occured) ->
    _last_event_time == null || (time_occured - _last_event_time) < get_running_average()

  # Check if we are not inside disabled time period (after accepting or rejecting recommended action)
  # ===================================

  not_inside_timeout = (current_time) ->
    _last_pattern_time == null || (current_time - _last_pattern_time) > _rec_timeout

  # Get current timestamp (in micro seconds)
  # ===================================

  get_current_ts = () ->
    new Date().getTime()

  # Check if str ends with suffix string
  # ===================================

  has_suffix = (str, suffix) ->
    str.indexOf(suffix, str.length - suffix.length) != -1
