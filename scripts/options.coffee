'use strict'

# Reset options method
reset_options = () ->
  $('#user-level-select').val('beginner')
  $('#rec-mode-select').val('semi-interactive')

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
