'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to get
# a unique user UUID
# ======================================

class @User

  # ===================================
  # Public methods
  # ===================================

  in_context: (callback) ->
    # Load user id from storage or generate new UUID
    chrome.storage.sync.get ['user_id'], (result) ->
      if result.user_id
        callback(result.user_id)
      else
        new_id = generate_uuid()
        chrome.storage.sync.set
          'user_id': new_id, ->
            callback(new_id)

  # ===================================
  # Private methods
  # ===================================

  generate_uuid = () ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else (r & 0x3|0x8)
        v.toString(16))

