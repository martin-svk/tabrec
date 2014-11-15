'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to connect to API
# and make GET or POST requests.
# ======================================

class @Connection
  _dbg = false

  constructor: (@url, @debug_mode) ->
    _dbg = @debug_mode

  # Public methods

  get_user: (id, callback) ->
    get_member(@url, 'users', id, callback)

  create_user: (data) ->
    post_member(@url, data, 'users')

  post_usage_logs: (data) ->
    post_collection(@url, data, 'usage_logs')

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
        console.log("Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        for event in data
          console.log("#{event['name']}")

  post_member = (url, data, resource) ->
    $.ajax "#{url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { user: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _dbg

  post_collection = (url, data, resource) ->
    $.ajax "#{url}/#{resource}",
      type: 'POST'
      dataType: 'json'
      data: { data: data }
      success: (data, textStatus, jqXHR) ->
        console.log("Status: #{textStatus}") if _dbg
