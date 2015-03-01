'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to connect to API
# and make GET or POST requests.
# ======================================

class @Connection
  debug_mode = null
  api_url = null

  constructor: () ->
    api_url = Constants.get_api_url()
    debug_mode = Constants.is_debug_mode()

  # Public methods

  get_user: (id, callback) ->
    get_member('users', id, callback)

  get_user_bstats: (id, callback) ->
    get_member('stats/browsing', id, callback)

  create_user: (data) ->
    post_member(data, 'users')

  post_usage_logs: (data) ->
    post_collection(data, 'logs/usage')

  # Private methods

  get_member = (resource, id, callback) ->
    $.ajax "#{api_url}/#{resource}/#{id}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        callback(null)
      success: (data, textStatus, jqXHR) ->
        callback(data)

  get_collection = (resource) ->
    $.ajax "#{api_url}/#{resource}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Error: #{textStatus}") if debug_mode
      success: (data, textStatus, jqXHR) ->
        if debug_mode
          for event in data
            console.log("#{event['name']}")

  post_member = (data, resource) ->
    $.ajax "#{api_url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { user: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if debug_mode

  post_collection = (data, resource) ->
    $.ajax "#{api_url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { data: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if debug_mode
