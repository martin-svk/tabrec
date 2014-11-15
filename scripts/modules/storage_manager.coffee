'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to interact with
# chrome storage API, it is also used
# to get a unique user UUID
# ======================================

class @StorageManager

  # ===================================
  # Public methods
  # ===================================

  load: () ->
    console.log("Loading from storage")

  save: () ->
    console.log("Saving to storage")

  get_user_id: () ->
    # Load user id from storage or generate new UUID
    console.log("Getting user id")
    return 123456

  # ===================================
  # Private methods
  # ===================================

  generate_uuid = () ->
    console.log("Generating uuid")
