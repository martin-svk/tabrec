'use strict'

# ======================================
# @author Martin Toma
#
# this class represents the compare
# pattern and contains logic to
# recognize it
# ======================================

class @ComparePattern
  # Constants
  PATTERN_SEQUENCE = null
  NAME = null
  DBG_MODE = null
  CURRENT_VERSION = null

  # Local variables
  _last_activated_tab_id = null
  _recorded = []
  _current_sequence = []

  constructor: () ->
    DBG_MODE = Constants.is_debug_mode()
    CURRENT_VERSION = Constants.get_current_activate_pattern_version()
    PATTERN_SEQUENCE = ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED']
    NAME = "COMPARE_#{CURRENT_VERSION}"

  pattern_sequence: () ->
    PATTERN_SEQUENCE

  current_sequence: () ->
    _current_sequence

  name: () ->
    NAME

  register_event: (event_name, event_data) ->
    if event_name == 'TAB_ACTIVATED'
      _current_sequence.push(event_name) if should_record_activate(event_data)
    else
      _current_sequence.push(event_name)

    console.log("Compare: current sequence: #{_current_sequence}") if DBG_MODE

  specific_conditions_satisfied: () ->
    if contains_only_two_different_ids(_recorded)
      clear_arrays()

  reset_states: () ->
    console.log("Compare: resetting states") if DBG_MODE
    clear_arrays()

  # Private methods
  # ======================================

  clear_arrays = () ->
    _recorded = []
    _current_sequence = []


  should_record_activate = (data) ->
    _recorded.push(data.tab_id)
    return true

  # Helper methods
  # ======================================

  contains_only_two_different_ids = (array) ->
    false
