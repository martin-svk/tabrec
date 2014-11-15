'use strict'

API_URL = 'http://tabber.fiit.stuba.sk'
#API_URL = 'http://localhost:9292'

# Reset options method
reset_options = () ->
  $('#user-level-select').val('beginner')
  $('#rec-mode-select').val('aggressive')

# Load options from chrome storage
load_options = () ->
  chrome.storage.sync.get ['user_level', 'rec_mode'], (result) ->
    if result.user_level and result.rec_mode
      $('#user-level-select').val(result.user_level)
      $('#rec-mode-select').val(result.rec_mode)
    else
      reset_options()

# Save options method
save_option = () ->
  userLevel = $('#user-level-select').val()
  recMode = $('#rec-mode-select').val()
  chrome.storage.sync.set
    'user_level': userLevel
    'rec_mode': recMode, ->
      chrome.storage.sync.get ['user_id'], (result) ->
        update_user(result.user_id, userLevel, recMode)

# Update user record on server
update_user = (id, exp, rec) ->
  $.ajax "#{API_URL}/users/#{id}",
    type: 'PUT'
    dataType: 'json'
    data: { user: {
      rec_mode: rec
      experience: exp
    } }
    success: (data, textStatus, jqXHR) ->
      swal('Success!', 'Your settings has been saved!', 'success')


# On save button submit
$('#save-settings').click ->
  save_option()

# On reset button click
$('#reset-settings').click ->
  reset_options()

# Load saved options when options page open
$(document).ready ->
  load_options()
