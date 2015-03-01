// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var API_URL;

  API_URL = Constants.get_api_url();

  $(function() {
    return chrome.storage.sync.get(['user_id'], function(result) {
      if (result.user_id) {
        $.ajax("" + API_URL + "/stats/browsing/" + result.user_id, {
          type: 'GET',
          dataType: 'json',
          success: function(data, textStatus, jqXHR) {
            $('#w-tabs-created').html(data.weekly.created);
            $('#w-tabs-closed').html(data.weekly.closed);
            $('#tabs-created').html(data.alltime.created);
            return $('#tabs-closed').html(data.alltime.closed);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            $('#w-tabs-created').html('N/A');
            $('#w-tabs-closed').html('N/A');
            $('#tabs-created').html('N/A');
            return $('#tabs-closed').html('N/A');
          }
        });
      }
      return $('#settings').on('click', function() {
        return chrome.tabs.create({
          url: 'options.html'
        });
      });
    });
  });

}).call(this);
