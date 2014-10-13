'use strict'

active = true

update_icon = () ->
  if active
    icon_name = 'active'
  else
    icon_name = 'inactive'
  chrome.browserAction.setIcon({path:'../images/icon_' + icon_name + '.png'})
  active = !active

chrome.browserAction.onClicked.addListener(update_icon)
update_icon()
