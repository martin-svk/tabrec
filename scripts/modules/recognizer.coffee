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
  _running_average_gap_inclusion_threshold = Constants.get_running_average_gap_inclusion_threshold()
  _max_running_average_event_gap = Constants.get_max_running_average_event_gap()
  _min_running_average_event_gap = Constants.get_min_running_average_event_gap()
  _accuracy = 100 # Time accuracy when comparing gaps (100 means 0.1 sec)

  _notifier = null
  _pattern_recognizers = []

  constructor: (user_id, session_id) ->
    _notifier = new Notifier(user_id)

    # Add pattern classes which will be recognized
    _pattern_recognizers.push(
      new MultiActivatePattern(), new ComparePattern(),
      new RefreshPattern(), new MultiClosePattern()
    )

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
  _running_average_bucket = []

  # ===================================
  # Event handlers
  # ===================================

  # Activate event handling
  # ===================================

  tab_activated = (active_info) ->
    time_occured = get_current_ts()
    tab_id = active_info.tabId

    # Filter outliers but save their event time
    if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
      _last_event_time = time_occured
      return

    # Update running average
    handle_running_average(time_occured)

    # Activate event data needed by pattern recognizers
    event_data =
      tab_id: tab_id
      tab_index: null

    chrome.tabs.get(tab_id, (tab) ->
      event_data.tab_index = tab.index

      # Record event
      record_event('TAB_ACTIVATED', time_occured, event_data)
    )

    # Updating last event time
    _last_event_time = time_occured

  # Generic event handling
  # ===================================

  tab_created = (tab) ->
    time_occured = get_current_ts()

    # Filter outliers but save their event time
    if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
      _last_event_time = time_occured
      return

    # Update running average
    handle_running_average(time_occured)

    # Record event
    record_event('TAB_CREATED', time_occured, {})

    # Updating last event time
    _last_event_time = time_occured

  tab_removed = (tab_id, remove_info) ->
    time_occured = get_current_ts()

    # Filter outliers but save their event time
    if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
      _last_event_time = time_occured
      return

    # Update running average
    handle_running_average(time_occured)

    # Record event
    record_event('TAB_REMOVED', time_occured, {})

    # Updating last event time
    _last_event_time = time_occured

  tab_moved = (tab_id, move_info) ->
    time_occured = get_current_ts()

    # Filter outliers but save their event time
    if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
      _last_event_time = time_occured
      return

    # Update running average
    handle_running_average(time_occured)

    # Record event
    record_event('TAB_MOVED', time_occured, {})

    # Updating last event time
    _last_event_time = time_occured

  tab_attached = (tab_id, attach_info) ->
    time_occured = get_current_ts()

    # Filter outliers but save their event time
    if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
      _last_event_time = time_occured
      return

    # Update running average
    handle_running_average(time_occured)

    # Record event
    record_event('TAB_ATTACHED', time_occured, {})

    # Updating last event time
    _last_event_time = time_occured

  tab_detached = (tab_id, detach_info) ->
    time_occured = get_current_ts()

    # Filter outliers but save their event time
    if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
      _last_event_time = time_occured
      return

    # Update running average
    handle_running_average(time_occured)

    # Record event
    record_event('TAB_DETACHED', time_occured, {})

    # Updating last event time
    _last_event_time = time_occured

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'
      time_occured = get_current_ts()

      # Filter outliers but save their event time
      if is_bottom_outlier(time_occured) || is_upper_outlier(time_occured)
        _last_event_time = time_occured
        return

      # Update running average
      handle_running_average(time_occured)

      # Update event data used by recognizers
      event_data =
        id: tab_id
        url: tab.url

      # Record event
      record_event('TAB_UPDATED', time_occured, event_data)

      # Updating last event time
      _last_event_time = time_occured

  # ===================================
  # Recording events if they fit into
  # running average
  # ===================================

  record_event = (event_name, time_occured, event_data) ->
    if inside_running_average(time_occured)
      # Inside running average gap
      update_current_sequences(event_name, event_data)
      if (pattern_name = some_pattern_occured()) && not_inside_timeout(get_current_ts())
        _notifier.show_pattern(pattern_name)
        _last_pattern_time = get_current_ts()
        reset_all_pattern_states()
    else
      # Outside running average gap
      reset_all_pattern_states()

  # Current state matches some pattern
  # this checks the global condition:
  # current sequence suffix must match
  # pattern sequence (to not have to
  # implement suffix matching in every
  # pattern class)
  # ===================================

  some_pattern_occured = () ->
    for pattern in _pattern_recognizers
      if has_suffix(pattern.current_sequence(), pattern.pattern_sequence()) && pattern.specific_conditions_satisfied()
        return pattern.name()
    return false

  # Will handle adding new time stamp to running average array or
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

  # Will add event to every registered patterns sequence
  # ===================================
  update_current_sequences = (event_name, event_data) ->
    for pattern in _pattern_recognizers
      pattern.register_event(event_name, event_data)

  # Will call reset methods on all active pattern recognizers
  # ===================================

  reset_all_pattern_states = () ->
    for pattern in _pattern_recognizers
      pattern.reset_states()

  # Check if we are inside thresholded gap timeout
  # ===================================

  inside_running_average = (time_occured) ->
    _last_event_time == null || in_threshold((time_occured - _last_event_time), get_running_average())

  # Check if we are not inside disabled time period (after accepting or rejecting recommended action)
  # ===================================

  not_inside_timeout = (current_time) ->
    _last_pattern_time == null || (current_time - _last_pattern_time) > _rec_timeout

  # Check for outliers
  # ===================================
  is_upper_outlier = (new_event_ts) ->
    _last_event_time != null && (new_event_ts - _last_event_time) > _max_running_average_event_gap

  is_bottom_outlier = (new_event_ts) ->
    # If event lasts less than 50 milliseconds
    _last_event_time != null && (new_event_ts - _last_event_time) < _min_running_average_event_gap


  # ===================================
  # Helper functions
  # ===================================

  # Check if time1 is < than time2 +/- some %
  in_threshold = (time1, time2) ->
    (time1 < (time2 + time2 * _running_average_gap_inclusion_threshold)) || (time1 < (time2 - time2 * _running_average_gap_inclusion_threshold))

  # Get current time stamp (in micro seconds)
  # ===================================

  get_current_ts = () ->
    new Date().getTime()

  # Check if str ends with suffix string
  # ===================================

  has_suffix = (str, suffix) ->
    str.indexOf(suffix, str.length - suffix.length) != -1
