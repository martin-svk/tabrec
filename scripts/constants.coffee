'use strict'

# ======================================
# @author Martin Toma
#
# Contains application wide constants
# ======================================

class @Constants
  DEBUG_MODE = false

  @is_debug_mode: ->
    DEBUG_MODE

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
