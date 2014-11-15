'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to interact with
# chrome storage API, it is also used
# to get a unique user UUID
# ======================================

class @UUID

  # ===================================
  # Public methods
  # ===================================

  load_or_generate: () ->
    # Load user id from storage or generate new UUID
    console.log("Getting user id")
    return 123456

  # ===================================
  # Private methods
  # ===================================

  generate_uuid = () ->
    console.log("Generating uuid")
