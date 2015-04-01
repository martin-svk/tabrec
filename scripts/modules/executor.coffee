'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to execute recommended
# action after user accepted it via notification
# ======================================

class @Executor
  _dbg_mode = null

  constructor: () ->
    _dbg_mode = Constants.get_debug_mode()

  execute: (pattern) ->
    console.log("Executing action for: #{pattern}") if _dbg_mode
