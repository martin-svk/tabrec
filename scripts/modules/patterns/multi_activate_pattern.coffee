'use strict'

# ======================================
# @author Martin Toma
#
# this class represents the multi
# activate patterns and contains
# logic to recognize it
# ======================================

class @MultiActivatePattern
  # Constants
  PATTERN_SEQUENCE = null
  NAME = null
  DIFF_ELEM_COUNT = 3
  DBG_MODE = null
  CURRENT_VERSION = null

  # Local variables
  _last_activated_tab_position = null
  _recorded = []
  _current_sequence = []

  constructor: () ->
    DBG_MODE = Constants.is_debug_mode()
    CURRENT_VERSION = Constants.get_current_activate_pattern_version()
    PATTERN_SEQUENCE = ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED']
    NAME = "MULTI_ACTIVATE_#{CURRENT_VERSION}"

  pattern_sequence: () ->
    PATTERN_SEQUENCE.toString()

  current_sequence: () ->
    _current_sequence.toString()

  name: () ->
    NAME

  register_event: (event_name, event_data) ->
    if event_name == 'TAB_ACTIVATED'
      _current_sequence.push(event_name) if should_record_activate(event_data)
    else
      _current_sequence.push(event_name)

    console.log("Multi activate: current sequence: #{_current_sequence}") if DBG_MODE

  # Check other conditions (suffix is checked in global recognizer)
  specific_conditions_satisfied: () ->
    # recorded array must contains at least 3 different ids
    if contains_different_elements(_recorded, DIFF_ELEM_COUNT)
      true
    else
      false

  reset_states: () ->
    console.log("Multi activate: resetting states") if DBG_MODE
    clear_arrays()

  # Private methods
  # ======================================

  should_record_activate = (data) ->
    tab_position = data.tab_index
    tab_id = data.tab_id

    if _last_activated_tab_position == null || not_next_to(tab_position, _last_activated_tab_position)
      _last_activated_tab_position = tab_position
      _recorded.push(tab_id)
      return true
    else
      _last_activated_tab_position = tab_position
      return false

  # Helper methods
  # ======================================

  # Check if tabs on pos1 and pos2 are adjacent
  not_next_to = (pos1, pos2) ->
    Math.abs(pos1 - pos2) != 1

  # Check if array contains x diffrent elements
  contains_different_elements = (array, number) ->
    tmp = []
    for elem in array
      if tmp.indexOf(elem) == -1
        tmp.push(elem)

    console.log("Array contains #{tmp.length} different elements") if DBG_MODE
    if tmp.length >= number
      return true
    else
      return false


  # Clear state variables
  clear_arrays = () ->
    _recorded = []
    _current_sequence = []
