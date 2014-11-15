'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to get
# a unique user UUID
# ======================================

class @Identifier

  # ===================================
  # Public methods
  # ===================================

  get_or_generate_id: () ->
    # Load user id from storage or generate new UUID
    id = chrome.storage.sync.get ['user_id'], (result) ->
      result.user_id

    if id
      return id
    else
      id = UUID.create(4)
      chrome.storage.sync.set
        'user_id': id
      return id
