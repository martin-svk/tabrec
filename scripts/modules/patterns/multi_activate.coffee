'use strict'

# ======================================
# @author Martin Toma
#
# this class represents the multi
# activate patterns and contains
# logic to recognize it
# ======================================

class @MultiActivate
  # Locals
  _dbg_mode = null
  _current_ma_version = null

  # Constants
  SEQUENCE = null
  NAME = null

  constructor: () ->
    _dbg_mode = Constants.is_debug_mode()
    _current_ma_version = Constants.get_current_activate_pattern_version()
    SEQUENCE = ['TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED', 'TAB_ACTIVATED']
    NAME = "MULTI_ACTIVATE_#{_current_ma_version}"

  sequence: () ->
    SEQUENCE

  name: () ->
    NAME
