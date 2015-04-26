'use strict'

API_URL = Constants.get_api_url()

# Reset options method
reset_options = () ->
  $('#user-level-select').val('advanced')
  $('#rec-mode-select').val('interactive')
  $('#other-plugins-cb').prop('checked', false)

# Load options from chrome storage
load_options = () ->
  chrome.storage.sync.get ['user_id', 'user_level', 'rec_mode', 'other_plugins'], (result) ->
    if result.user_id
      $('#uid').text(result.user_id)
    else
      $('#uid').text('not yet generated')

    if result.user_level and result.rec_mode
      $('#user-level-select').val(result.user_level)
      $('#rec-mode-select').val(result.rec_mode)
      $('#other-plugins-cb').prop('checked', result.other_plugins)
    else
      reset_options()

# Save options method
save_option = () ->
  userLevel = $('#user-level-select').val()
  recMode = $('#rec-mode-select').val()
  otherPlugins = $('#other-plugins-cb').prop('checked')
  chrome.storage.sync.set
    'other_plugins': otherPlugins
    'user_level': userLevel
    'rec_mode': recMode, ->
      chrome.storage.sync.get ['user_id'], (result) ->
        update_user(result.user_id, userLevel, recMode, otherPlugins)
        swal('Success!', 'Some changes will take effect after browser restart.', 'success')

# Update user record on server
update_user = (id, exp, rec, op) ->
  $.ajax "#{API_URL}/users/#{id}",
    type: 'PUT'
    dataType: 'json'
    data: { user: {
      rec_mode: rec
      experience: exp
      other_plugins: op
    } }

# On save button submit
$('#save-settings').click ->
  save_option()

# On reset button click
$('#reset-settings').click ->
  reset_options()

# Load saved options when options page open
$(document).ready ->
  substitute_for_new_modes()
  load_options()

# Migration from old interactive -> semi-interactive -> aggressive
# to interactive -> automatic
substitute_for_new_modes = () ->
  chrome.storage.sync.get ['rec_mode'], (result) ->
    if result.rec_mode
      if result.rec_mode == 'semi-interactive'
        chrome.storage.sync.set
          'rec_mode': 'interactive'
      else if result.rec_mode == 'aggressive'
        chrome.storage.sync.set
          'rec_mode': 'automatic'
