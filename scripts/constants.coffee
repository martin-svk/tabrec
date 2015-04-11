'use strict'

# ======================================
# @author Martin Toma
#
# Contains application wide constants
# ======================================

class @Constants
  DEBUG_MODE = false
  USAGE_LOGGING = true
  CURRENT_MULTI_ACTIVATE_VERSION = 'V4'

  @is_debug_mode: ->
    DEBUG_MODE

  @usage_logging_on: ->
    USAGE_LOGGING

  @get_api_url: ->
    if DEBUG_MODE
      'http://localhost:9292'
    else
      'http://tabber.fiit.stuba.sk:9292'

  @get_batch_size: ->
    if DEBUG_MODE
      5
    else
      50

  @get_max_running_average_bucket_size: ->
    # Last 100 events
    100

  @get_rec_timeout: ->
    if DEBUG_MODE
      # 30 sec
      30000
    else
      # 3 min
      3 * 60000

  @get_current_activate_pattern_version: ->
    CURRENT_MULTI_ACTIVATE_VERSION
