'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to show specific
# notification in chrome user interface.
# ======================================

class @Notifier
  debug_mode = null

  constructor: () ->
    debug_mode = Constants.is_debug_mode()

  notify: (pattern) ->
    console.log("Notification: pattern occured: #{pattern}") if debug_mode
