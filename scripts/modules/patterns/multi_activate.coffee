'use strict'

# ======================================
# @author Martin Toma
#
# this class represents the multi
# activate patterns and contains
# logic to recognize it
# ======================================

class @MultiActivate
  # Constants
  SEQUENCE = null
  NAME = null
  DIFF_ELEM_COUNT = 3

  # Local variables
  _dbg_mode = null
  _current_ma_version = null

  _last_activated_tab_position = null
  _recorded = []

  constructor: () ->
    _dbg_mode = Constants.is_debug_mode()
    _current_ma_version = Constants.get_current_activate_pattern_version()
    SEQUENCE = ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED']
    NAME = "MULTI_ACTIVATE_#{_current_ma_version}"

  sequence: () ->
    SEQUENCE

  name: () ->
    NAME

  should_record_activate: (tab_position, tab_id) ->
    if _last_activated_tab_position == null || not_next_to(tab_position, _last_activated_tab_position)
      _last_activated_tab_position = tab_position
      _recorded.push(tab_id)
      return true
    else
      _last_activated_tab_position = tab_position
      return false

  all_conditions_satisfied: () ->
    # recorded array must contains at least 3 different ids
    contains_different_elements(_recorded, DIFF_ELEM_COUNT)

  reset_states: () ->
    _recorded = []

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

    console.log("Array contains #{tmp.length} different elements") if _dbg_mode
    if tmp.length >= number
      return true
    else
      return false

