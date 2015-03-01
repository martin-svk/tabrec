'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to connect to API
# and make GET or POST requests.
# ======================================

class @Connection
  debug_mode = Constants.is_debug_mode()
  api_url = Constants.get_api_url()

  # Public methods

  get_user: (id, callback) ->
    get_member(api_url, 'users', id, callback)

  get_user_bstats: (id, callback) ->
    get_member(api_url, 'stats/browsing', id, callback)

  create_user: (data) ->
    post_member(api_url, data, 'users')

  post_usage_logs: (data) ->
    post_collection(api_url, data, 'logs/usage')

  # Private methods

  get_member = (url, resource, id, callback) ->
    $.ajax "#{url}/#{resource}/#{id}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        callback(null)
      success: (data, textStatus, jqXHR) ->
        callback(data)

  get_collection = (url, resource) ->
    $.ajax "#{url}/#{resource}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Error: #{textStatus}") if debug_mode
      success: (data, textStatus, jqXHR) ->
        if debug_mode
          for event in data
            console.log("#{event['name']}")

  post_member = (url, data, resource) ->
    $.ajax "#{url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { user: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if debug_mode

  post_collection = (url, data, resource) ->
    $.ajax "#{url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { data: data }
      success: (data, textStatus, jqXHR) ->
        if debug_mode
          console.log("Status: #{textStatus}")
          console.log(data)
