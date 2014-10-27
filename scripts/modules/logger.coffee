'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to show specific
# notification in chrome user interface.
# ======================================

class @Logger
  constructor: (@url) ->

  # Public methods

  log: (message) ->
    console.log("Logging: #{message} to server: #{@url}")

  getUser: (id) ->
    get(@url, 'users', id)

  # Private methods

  get = (url, resource, id) =>
    $.ajax "#{url}/#{resource}/#{id}",
        type: 'GET'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
            console.log("Error: #{textStatus}")
        success: (data, textStatus, jqXHR) ->
            console.log("User id: #{data['id']} experience: #{data['experience']} rec_mode: #{data['rec_mode']}")

