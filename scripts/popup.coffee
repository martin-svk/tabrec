'use strict'

STATS_URL = 'http://tabber.fiit.stuba.sk'
#STATS_URL = 'http://localhost:9292'

$ ->
  chrome.storage.sync.get ['user_id'], (result) ->
    if result.user_id
      $.ajax "#{STATS_URL}/bstats/#{result.user_id}",
        type: 'GET'
        dataType: 'json'
        success: (data, textStatus, jqXHR) ->
          $('#w-tabs-created').html(data.weekly.created)
          $('#w-tabs-closed').html(data.weekly.closed)
          $('#tabs-created').html(data.alltime.created)
          $('#tabs-closed').html(data.alltime.closed)
        error: (jqXHR, textStatus, errorThrown) ->
          $('#w-tabs-created').html('N/A')
          $('#w-tabs-closed').html('N/A')
          $('#tabs-created').html('N/A')
          $('#tabs-closed').html('N/A')

    $('#settings').on('click', ->
      chrome.tabs.create({url: 'options.html'})
    )
