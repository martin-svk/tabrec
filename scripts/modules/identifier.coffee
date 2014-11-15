'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to get
# a unique user UUID
# ======================================

class @Indentifier

  # ===================================
  # Public methods
  # ===================================

  load_or_generate_id: () ->
    # Load user id from storage or generate new UUID
    uid = chrome.storage.sync.get ['user_id'], (result) ->
      result.user_id

    if uid
      return uid
    else
      uid = generate_uuid()
      chrome.storage.sync.set
        'user_id': uid
      return uid

  # ===================================
  # Private methods
  # ===================================

  generate_uuid = () ->
    console.log("Generating uuid")
