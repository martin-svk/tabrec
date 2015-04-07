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
  _current_ma_version = Constants.get_current_activate_pattern_version()
  _max_running_average_bucket_size = Constants.get_max_running_average_bucket_size()
  _accuracy = 100
  _notifier = null

  constructor: (user_id, session_id) ->
    _notifier = new Notifier(user_id)

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
  _last_activated_tab_position = null

  _current_sequence = []
  _running_average_bucket = []

  # This is activate pattern with sort advice
  _activate_pattern =
    sequence: ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED']
    name: "MULTI_ACTIVATE_#{_current_ma_version}"

  # TODO: load from API: conn.get_patterns()
  _patterns = [ _activate_pattern ]

  # ===================================
  # Event handlers
  # ===================================

  # Activate event handling

  tab_activated = (active_info) ->
    tab_id = active_info.tabId
    chrome.tabs.get(tab_id, (tab) ->
      position = tab.index
      if _last_activated_tab_position == null || not_next_to(position, _last_activated_tab_position)
        process_event('TAB_ACTIVATED', get_current_ts())

      # Update last tab position
      _last_activated_tab_position = position
    )

  # Generic event handling

  tab_created = (tab) ->
    process_event('TAB_CREATED', get_current_ts())

  tab_removed = (tab_id, remove_info) ->
    process_event('TAB_REMOVED', get_current_ts())

  tab_moved = (tab_id, move_info) ->
    process_event('TAB_MOVED', get_current_ts())

  tab_attached = (tab_id, attach_info) ->
    process_event('TAB_ATTACHED', get_current_ts())

  tab_detached = (tab_id, detach_info) ->
    process_event('TAB_DETACHED', get_current_ts())

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'
      process_event('TAB_UPDATED', get_current_ts())

  # ===================================
  # Pattern recognizing
  # ===================================

  process_event = (event_name, time_occured) ->
    # Update last event time
    handle_running_average(time_occured)

    # Check for pattern
    if _last_event_time == null || (time_occured - _last_event_time) < get_running_average()
      _current_sequence.push(event_name)
      if (pattern = current_state_is_pattern(_current_sequence)) && not_inside_timeout(get_current_ts())
        _notifier.show_pattern(pattern)
        _last_pattern_time = get_current_ts()
        _current_sequence = []
    else
      # Gap is wider
      _current_sequence = []

    # Updating last event time
    _last_event_time = time_occured

  # ===================================
  # Helper functions
  # ===================================

  # Check if current state contains pattern sequence suffix
  current_state_is_pattern = (sequence) ->
    console.log("Current sequence: #{sequence}") if _dbg_mode
    for pattern in _patterns
      if has_suffix(sequence.toString(), pattern.sequence.toString())
        return pattern.name
    return false

  # Check if we are not inside disabled time period (after accepting or rejecting recommended action)
  not_inside_timeout = (current_time) ->
    if _last_pattern_time == null || current_time - _last_pattern_time > _rec_timeout
      return true
    else
      return false

  # Get current timestamp (in micro seconds)
  get_current_ts = () ->
    new Date().getTime()

  # Check if str ends with suffix string
  has_suffix = (str, suffix) ->
    str.indexOf(suffix, str.length - suffix.length) != -1

  # Check if tabs on pos1 and pos2 are adjacent
  not_next_to = (pos1, pos2) ->
    Math.abs(pos1 - pos2) != 1

  # Will handle adding new timestamp to running average array or
  # replace oldest value when reaching maximum bucket size
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
  # TODO: performance improve by some approximation...
  get_running_average = () ->
    i = _running_average_bucket.length
    sum = 0
    while (i--)
      sum += _running_average_bucket[i]

    # Times _accuracy to make it micro seconds
    avg = parseInt((sum / _running_average_bucket.length) * _accuracy, 10)
    console.log("Current running average: #{avg} micro seconds.") if _dbg_mode

    return avg
