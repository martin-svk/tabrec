'use strict'

# ======================================
# @author Martin Toma
#
# Contains logic to show specific
# notification in chrome user interface.
# ======================================

class @Notifier
  _conn = new Connection()
  _executor = new Executor()
  _debug_mode = null
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

  revert_notification_options =
    type: 'basic'
    iconUrl: 'images/revert_notification.png'
    title: 'Action was performed!'
    message: 'Dont like what happened? Click revert to load previous state.'
    buttons: [
        title: 'Revert'
        iconUrl: 'images/revert.png'
    ]

  constructor: (user_id) ->
    _debug_mode = Constants.is_debug_mode()
    _uid = user_id
    chrome.notifications.onButtonClicked.addListener(notification_button_clicked)
    chrome.notifications.onClicked.addListener(notification_clicked)

  show_pattern: (pattern) ->
    _pattern = pattern
    console.log("Notification: pattern occured: #{_pattern}") if _debug_mode
    chrome.notifications.create("pattern_#{new Date().getTime()}", multi_activate_notification_options, (id) -> )

  # ===================================
  # Private functions
  # ===================================

  show_revert = () ->
    chrome.notifications.create("revert_#{new Date().getTime()}", revert_notification_options, (id) -> )

  # ===================================
  # Event handlers
  # ===================================

  # Clicked on buttons
  # ===================================

  notification_button_clicked = (notif_id, button_index) ->
    # Pattern notification
    if notif_id.indexOf('pattern') == 0
      if button_index == 0
        send_resolution('ACCEPTED')
        _executor.execute(_pattern)
        show_revert()
      else if button_index == 1
        send_resolution('REJECTED')
    # Revert notification
    else if notif_id.indexOf('revert') == 0
      if button_index == 0
        send_resolution('REVERTED')
        _executor.revert(_pattern)
    # Clear notification
    chrome.notifications.clear(notif_id, (cleared) ->)

  # Clicking on non button area (clear)
  # ===================================

  notification_clicked = (notif_id) ->
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
