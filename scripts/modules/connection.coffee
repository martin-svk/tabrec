'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to connect to API
# and make GET or POST requests.
# ======================================

class @Connection
  constructor: (@url) ->

  # Public methods

  get_user: (id) ->
    get_member(@url, 'users', id)

  get_events: ->
    get_collection(@url, 'events')

  post_usage_logs: (data) ->
    post_collection(data)

  # Private methods

  get_member = (url, resource, id) ->
    $.ajax "#{url}/#{resource}/#{id}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("User id: #{data['id']} experience: #{data['experience']} rec_mode: #{data['rec_mode']}")

  get_collection = (url, resource) ->
    $.ajax "#{url}/#{resource}",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        for event in data
          console.log("#{event['name']}")

  post_collection = (data) ->
    console.log("Posting collection of #{data.length} items.")
