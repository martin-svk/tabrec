'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to get
# a unique user UUID
# ======================================

class @User
  _conn = null

  constructor: () ->
    _conn = new Connection()

  # ===================================
  # Public methods
  # ===================================

  # In context of user and session ids
  in_context: (callback) ->
    # Load user id from storage or generate new user
    chrome.storage.sync.get ['user_id', 'rec_mode'], (result) ->
      session_id = generate_uuid()
      if result.user_id and result.rec_mode
        create_if_not_exists(result.user_id)
        callback(result.user_id, session_id, result.rec_mode)
      else
        new_id = generate_uuid()
        def_mode = 'default'
        chrome.storage.sync.set
          'user_id': new_id
          'rec_mode': def_mode, ->
            create_user(new_id)
            callback(new_id, session_id, def_mode)

  # ===================================
  # Private methods
  # ===================================

  generate_uuid = () ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else (r & 0x3|0x8)
        v.toString(16))

  create_if_not_exists = (id) ->
    _conn.get_user(id, (user) ->
      unless user
        create_user(id)
    )

  create_user = (id) ->
    _conn.create_user({
      id: id
      rec_mode: 'default'
      experience: 'default'
    })
