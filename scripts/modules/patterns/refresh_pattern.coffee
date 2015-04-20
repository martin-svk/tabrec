'use strict'

# ======================================
# @author Martin Toma
#
# this class represents the refresh
# pattern and contains logic to
# recognize it
# ======================================

class @RefreshPattern
  # Constants
  PATTERN_SEQUENCE = null
  NAME = null
  DBG_MODE = null
  CURRENT_VERSION = null

  # Local variables
  _recorded = []
  _current_sequence = []
  _last_update_url = ""

  constructor: () ->
    DBG_MODE = Constants.is_debug_mode()
    CURRENT_VERSION = Constants.get_current_refresh_pattern_version()
    PATTERN_SEQUENCE = ['TAB_UPDATED', 'TAB_UPDATED', 'TAB_UPDATED']
    NAME = "REFRESH_#{CURRENT_VERSION}"

  pattern_sequence: () ->
    PATTERN_SEQUENCE.toString()

  current_sequence: () ->
    _current_sequence.toString()

  name: () ->
    NAME

  register_event: (event_name, event_data) ->
    if event_name == 'TAB_UPDATED'
      _current_sequence.push(event_name) if should_record_update(event_data)
      console.log("Refresh: current sequence: #{_current_sequence}") if DBG_MODE

  specific_conditions_satisfied: () ->
    return true # No more special conditions

  reset_states: () ->
    console.log("Refresh: resetting states") if DBG_MODE
    clear_arrays()

  # Private methods
  # ======================================

  clear_arrays = () ->
    _recorded = []
    _current_sequence = []

  should_record_update = (data) ->
    url = data.url
    if _recorded.length < 2 || same_tab_reloading(_recorded, url)
      _recorded.push(url)
      return true
    else
      return false

  # Helper methods
  # ======================================

  same_tab_reloading = (array, url) ->
    all_same = true
    for _url in array
      if _url != url
        all_same = false
    return all_same
