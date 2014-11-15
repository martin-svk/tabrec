'use strict'

# Reset options method
ResetOptions = () ->
  $('#user-level-select').val('beginner')
  $('#rec-mode-select').val('semi-interactive')

# Load options from chrome storage
LoadOptions = () ->
  chrome.storage.sync.get ['user_level', 'rec_mode'], (result) ->
    if result.user_level and result.rec_mode
      $('#user-level-select').val(result.user_level)
      $('#rec-mode-select').val(result.rec_mode)
    else
      ResetOptions()

# Save options method
SaveOptions = () ->
  userLevel = $('#user-level-select').val()
  recMode = $('#rec-mode-select').val()
  chrome.storage.sync.set
    'user_level': userLevel
    'rec_mode': recMode, ->
      swal('Success!', 'Your settings has been saved!', 'success')

# On save button submit
$('#save-settings').click ->
  SaveOptions()

# On reset button click
$('#reset-settings').click ->
  ResetOptions()

# Load saved options when options page open
$(document).ready ->
  LoadOptions()
