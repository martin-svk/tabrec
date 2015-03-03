'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to log information
# about provided recommendations and
# its resutions (accept/reject).
# It interacts with Log table in API.
# ======================================

class @Logger
  constructor: (@connection) ->

  # Public methods

  start: (message) ->
    console.log("Recommendation logger has started!")

  # Private methods

  save_log = (event) ->
    console.log("Saved event: #{event}")
