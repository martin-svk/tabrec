'use strict'

# Save options method
SaveOptions = ->
  console.log('Settings saved.')

# On save button submit
$('#save-options').click ->
  new SaveOptions()

