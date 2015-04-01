'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to connect to API
# and make GET or POST requests.
# ======================================

class @Connection
  _debug_mode = null
  _api_url = null

  constructor: () ->
    _api_url = Constants.get_api_url()
    _debug_mode = Constants.is_debug_mode()

  # Public methods
  # ======================================

  # General

  get_user: (id, callback) ->
    get_member('users', id, callback)

  get_user_bstats: (id, callback) ->
    get_member('stats/browsing', id, callback)

  post_usage_logs: (data) ->
    post_collection(data, 'logs/usage')

  # Specific

  create_user: (user_data) ->
    $.ajax "#{_api_url}/users",
      type: 'POST'
      dataType: 'json'
      data: { user: user_data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _debug_mode

  create_rec_log: (log_data) ->
    console.log(log_data) if _debug_mode
    $.ajax "#{_api_url}/logs/rec",
      type: 'POST'
      dataType: 'json'
      data: { log: log_data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _debug_mode

  # Private methods
  # ======================================

  get_member = (resource, id, callback) ->
    $.ajax "#{_api_url}/#{resource}/#{id}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        callback(null)
      success: (data, textStatus, jqXHR) ->
        callback(data)

  get_collection = (resource) ->
    $.ajax "#{_api_url}/#{resource}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Error: #{textStatus}") if _debug_mode
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _debug_mode

  post_member = (data, resource) ->
    $.ajax "#{_api_url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { data: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _debug_mode

  post_collection = (data, resource) ->
    $.ajax "#{_api_url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { data: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _debug_mode
