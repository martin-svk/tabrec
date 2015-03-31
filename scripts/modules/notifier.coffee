'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to show specific
# notification in chrome user interface.
# ======================================

class @Notifier
  debug_mode = null
  tab_sort_notification_options =
    type: 'basic'
    iconUrl: 'images/notification.png'
    title: 'Pattern detected!'
    message: 'Looks like you are looking for some tabs, need help?'
    buttons: [
        title: 'Accept'
        iconUrl: 'images/accept.png'
      ,
        title: 'Reject'
        iconUrl: 'images/reject.png'
    ]

  constructor: () ->
    debug_mode = Constants.is_debug_mode()
    chrome.notifications.onButtonClicked.addListener(notification_button_clicked)
    chrome.notifications.onClicked.addListener(notification_clicked)

  notify: (pattern) ->
    console.log("Notification: pattern occured: #{pattern}") if debug_mode
    chrome.notifications.create("notification_#{new Date().getTime()}", tab_sort_notification_options, (id) -> )

  # ===================================
  # Event handlers
  # ===================================

  notification_button_clicked = (notif_id, button_index) ->
    if button_index == 0
      console.log('recommendation accepted') if debug_mode
    else if button_index == 1
      console.log('recommendation rejected') if debug_mode
    # Clear
    chrome.notifications.clear(notif_id, (cleared) ->)

  notification_clicked = (notif_id) ->
    console.log('recommendation accepted') if debug_mode
    # Clear
    chrome.notifications.clear(notif_id, (cleared) ->)

