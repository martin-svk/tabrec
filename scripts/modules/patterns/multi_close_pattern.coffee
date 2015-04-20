'use strict'

# ======================================
# @author Martin Toma
#
# this class represents the multi
# close pattern and contains logic to
# recognize it
# ======================================

class @MultiClosePattern
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
    CURRENT_VERSION = Constants.get_current_close_pattern_version()
    PATTERN_SEQUENCE = ['TAB_REMOVED', 'TAB_REMOVED', 'TAB_REMOVED']
    NAME = "MULTI_CLOSE_#{CURRENT_VERSION}"

  pattern_sequence: () ->
    PATTERN_SEQUENCE.toString()

  current_sequence: () ->
    _current_sequence.toString()

  name: () ->
    NAME

  register_event: (event_name, event_data) ->
    if event_name == 'TAB_REMOVED'
      if should_record_remove_event(event_data)
        _current_sequence.push(event_name)
        console.log("Multi remove: current sequence: #{_current_sequence}") if DBG_MODE

  specific_conditions_satisfied: () ->
      return true # No specific conditions

  reset_states: () ->
    console.log("Multi remove: resetting states") if DBG_MODE
    clear_arrays()

  # Private methods
  # ======================================

  clear_arrays = () ->
    _recorded = []
    _current_sequence = []

  # Helper methods
  # ======================================

  should_record_remove_event = (event_data) ->
    _recorded.push(event_data)
    return true
