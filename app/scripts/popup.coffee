'use strict'

# Recommendation are on by default
# need to store to user settings storage
active = true

# Change browser action icon function
updateIcon = (val) ->
  if val
    iconName = 'active'
  else
    iconName = 'inactive'
  active = val
  chrome.browserAction.setIcon({path:'../images/icon_' + iconName + '.png'})

# Change browser action icon based on value of this checkbox
$('#tabrec-status').change ->
  updateIcon($(this).prop('checked'))

$(document).ready ->
  $('#tabrec-status').prop('checked', active)

