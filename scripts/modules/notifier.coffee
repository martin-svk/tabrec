'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to show specific
# notification in chrome user interface.
# ======================================

class @Notifier
  _debug_mode = null
  _conn = new Connection()
  _pattern = null
  _uid = null

  multi_activate_notification_options =
    type: 'basic'
    iconUrl: 'images/notification.png'
    title: 'Recommendation available!'
    message: 'Are you looking for something? We can sort all your tabs by their domains.'
    buttons: [
        title: 'Accept'
        iconUrl: 'images/accept.png'
      ,
        title: 'Reject'
        iconUrl: 'images/reject.png'
    ]

  constructor: (user_id) ->
    _debug_mode = Constants.is_debug_mode()
    _uid = user_id
    chrome.notifications.onButtonClicked.addListener(notification_button_clicked)
    chrome.notifications.onClicked.addListener(notification_clicked)

  notify: (pattern) ->
    _pattern = pattern
    console.log("Notification: pattern occured: #{_pattern}") if _debug_mode
    chrome.notifications.create("#{_pattern}_#{new Date().getTime()}", multi_activate_notification_options, (id) -> )

  # ===================================
  # Event handlers
  # ===================================

  notification_button_clicked = (notif_id, button_index) ->
    if button_index == 0
      send_resolution('ACCEPTED')
      # _executor.execute(_pattern)
    else if button_index == 1
      send_resolution('REJECTED')
    chrome.notifications.clear(notif_id, (cleared) ->)

  notification_clicked = (notif_id) ->
    send_resolution('ACCEPTED')
    # _executor.execute(_pattern)
    chrome.notifications.clear(notif_id, (cleared) ->)

  # ===================================
  # Helper functions
  # ===================================

  send_resolution = (resolution) ->
    _conn.create_rec_log(
      pattern: _pattern
      resolution: resolution
      user_id: _uid
    )
