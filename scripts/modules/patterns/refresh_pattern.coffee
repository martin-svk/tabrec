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
      _current_sequence.push(event_name)
      _recorded.push(event_data)
      console.log("Refresh: current sequence: #{_current_sequence}") if DBG_MODE

  specific_conditions_satisfied: () ->
    if one_tab_refreshed_at_least_3_times()
      return true
    else
      return false

  reset_states: () ->
    console.log("Refresh: resetting states") if DBG_MODE
    clear_arrays()

  # Private methods
  # ======================================

  clear_arrays = () ->
    _recorded = []
    _current_sequence = []

  # Helper methods
  # ======================================

  one_tab_refreshed_at_least_3_times = () ->
    counter = 0

    for obj in _recorded
      tab_id = obj.id
      tab_url = obj.url

      for inner_obj in _recorded
        if tab_id == inner_obj.id and tab_url == inner_obj.url
          counter += 1
        # Check if there are 3
        if counter == 3
          console.log("Some tab was reloaded 3 times!")
          return true

      # Refresh counter for next object comparing
      counter = 0

    # No tab was refreshed 3 times
    console.log("No tab was reloaded 3 times!")
    return false
