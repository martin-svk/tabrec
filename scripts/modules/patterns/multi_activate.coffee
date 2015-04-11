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

  # Helper methods
  # ======================================

  # Check if tabs on pos1 and pos2 are adjacent
  not_next_to = (pos1, pos2) ->
    Math.abs(pos1 - pos2) != 1
