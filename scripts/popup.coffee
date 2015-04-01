'use strict'

API_URL = Constants.get_api_url()

$ ->
  chrome.storage.sync.get ['user_id'], (result) ->
    if result.user_id
      # Browsing stats
      $.ajax "#{API_URL}/stats/browsing/#{result.user_id}",
        type: 'GET'
        dataType: 'json'
        success: (data, textStatus, jqXHR) ->
          $('#tabs-created').html(data.alltime.created)
          $('#tabs-closed').html(data.alltime.closed)
        error: (jqXHR, textStatus, errorThrown) ->
          $('#tabs-created').html('N/A')
          $('#tabs-closed').html('N/A')

      # Rec stats
      $.ajax "#{API_URL}/stats/rec/#{result.user_id}",
        type: 'GET'
        dataType: 'json'
        success: (data, textStatus, jqXHR) ->
          $('#recs-accepted').html(data.accepted)
          $('#recs-rejected').html(data.rejected)
        error: (jqXHR, textStatus, errorThrown) ->
          $('#recs-accepted').html('N/A')
          $('#recs-rejected').html('N/A')

  $('#settings').on 'click', ->
    chrome.tabs.create
      url: chrome.runtime.getURL('options.html')
      active: true
