'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to get
# a unique user UUID
# ======================================

class @StorageManager

  # ===================================
  # Public methods
  # ===================================

  ensure_uuid_in_storage: () ->
    # Load user id from storage or generate new UUID
    chrome.storage.sync.get ['user_id'], (result) ->
      unless result.user_id
        chrome.storage.sync.set
          'user_id': generate_uuid()

  # ===================================
  # Private methods
  # ===================================

  generate_uuid = () ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else (r & 0x3|0x8)
        v.toString(16))

