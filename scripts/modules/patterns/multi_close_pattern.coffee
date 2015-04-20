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
      _current_sequence.push(event_name)
      record_remove_event_data(event_data)
      console.log("Multi close: current sequence: #{_current_sequence}") if DBG_MODE

  specific_conditions_satisfied: () ->
    if three_consecutive_tab_removes_on_same_domain()
      return true
    else
      return false

  reset_states: () ->
    console.log("Multi close: resetting states") if DBG_MODE
    clear_arrays()

  # Private methods
  # ======================================

  clear_arrays = () ->
    _recorded = []
    _current_sequence = []

  record_remove_event_data = (event_data) ->
    url = event_data.url
    domain = get_domain(url)
    _recorded.push(domain)

  three_consecutive_tab_removes_on_same_domain = () ->
    return false # Disable for now

  # Helper methods
  # ======================================

  get_domain = (url) ->
    url_obj = new URL(url)
    subdomain = url_obj.hostname
    array = subdomain.split('.')
    top_level_domain = array.pop()
    return "#{array.pop()}.#{top_level_domain}"
