'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to log information
# about provided recommendations and
# its resutions (accepted/rejected/automatic)
# it interacts with Log table in API
# ======================================

class @Logger
  dbg_mode = Constants.is_debug_mode()
  conn = new Connection()
  notifier = new Notifier()
  uid = null
  sid = null

  constructor: (user_id, session_id) ->
    uid = user_id
    sid = session_id

  # ===================================
  # Public methods
  # ===================================

  start: () ->
    console.log("Rec logger has started!") if dbg_mode
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

  # This is activate pattern with sort advice
  _activate_pattern = ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED']

  # TODO: load from API: conn.get_patterns()
  _patterns = [ _activate_pattern ]

  # ===================================
  # Event handlers
  # ===================================

  tab_created = (tab) ->
    process_event('TAB_CREATED', get_current_ts())

  tab_removed = (tab_id, remove_info) ->
    process_event('TAB_REMOVED', get_current_ts())

  tab_activated = (active_info) ->
    process_event('TAB_ACTIVATED', get_current_ts())

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
      if current_state_is_pattern(_current_sequence)
        notifier.notify(_current_sequence)
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
    console.log("Current sequence: #{sequence}") if dbg_mode
    for pattern in _patterns
      if sequence.toString().indexOf(pattern.toString()) >= 0
        return true
    return false

  get_current_ts = () ->
    new Date().getTime()
