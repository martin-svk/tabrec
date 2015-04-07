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
  _max_gap = Constants.get_max_gap()
  _current_sequence = []
  _last_pattern_time = null

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

  _last_activated_tab_position = null

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
    if _last_event_time == null || (time_occured - _last_event_time) < _max_gap
      _current_sequence.push(event_name)
      if (pattern = current_state_is_pattern(_current_sequence)) && not_inside_timeout(get_current_ts())
        _notifier.show_pattern(pattern)
        _last_pattern_time = get_current_ts()
        _current_sequence = []
    else
      # Gap is wider
      _current_sequence = []

    # Always update last event
    _last_event_time = time_occured

  # ===================================
  # Helper functions
  # ===================================

  current_state_is_pattern = (sequence) ->
    console.log("Current sequence: #{sequence}") if _dbg_mode
    for pattern in _patterns
      if has_suffix(sequence.toString(), pattern.sequence.toString())
        return pattern.name
    return false

  not_inside_timeout = (current_time) ->
    if _last_pattern_time == null || current_time - _last_pattern_time > _rec_timeout
      return true
    else
      return false

  get_current_ts = () ->
    new Date().getTime()

  has_suffix = (str, suffix) ->
    str.indexOf(suffix, str.length - suffix.length) != -1

  not_next_to = (pos1, pos2) ->
    Math.abs(pos1 - pos2) != 1
