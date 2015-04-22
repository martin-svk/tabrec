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
    message: 'Are you looking for something? We can help. Note that executed action can be reverted.'
    buttons: [
        title: 'Accept'
        iconUrl: 'images/accept.png'
      ,
        title: 'Reject'
        iconUrl: 'images/reject.png'
    ]

  compare_notification_options =
    type: 'basic'
    iconUrl: 'images/notification_yesno.png'
    title: 'Pattern detected!'
    message: 'Are you comparing the contents of two tabs?'
    buttons: [
        title: 'Yes'
        iconUrl: 'images/accept.png'
      ,
        title: 'No'
        iconUrl: 'images/reject.png'
    ]

  refresh_notification_options =
    type: 'basic'
    iconUrl: 'images/notification_yesno.png'
    title: 'Pattern detected!'
    message: 'Are you watching for content updates in specific tab?'
    buttons: [
        title: 'Yes'
        iconUrl: 'images/accept.png'
      ,
        title: 'No'
        iconUrl: 'images/reject.png'
    ]

  multi_close_notification_options =
    type: 'basic'
    iconUrl: 'images/notification_yesno.png'
    title: 'Pattern detected!'
    message: 'Have you just finished some browsing task?'
    buttons: [
        title: 'Yes'
        iconUrl: 'images/accept.png'
      ,
        title: 'No'
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
    # chrome.notifications.onClicked.addListener(notification_clicked)
    # chrome.notifications.onClosed.addListener(notification_closed)

  show_pattern: (pattern) ->
    _pattern = pattern
    console.log("Notification: pattern occured: #{_pattern}") if _debug_mode
    show_pattern_notification()

  # ===================================
  # Private functions
  # ===================================

  show_revert = () ->
    chrome.notifications.create("revert_#{new Date().getTime()}", revert_notification_options, (id) -> )

  show_pattern_notification = () ->
    options = null

    if _pattern.indexOf('MULTI_ACTIVATE') == 0
      options = multi_activate_notification_options
    else if _pattern.indexOf('COMPARE') == 0
      options = compare_notification_options
    else if _pattern.indexOf('REFRESH') == 0
      options = refresh_notification_options
    else if _pattern.indexOf('MULTI_CLOSE') == 0
      options = multi_close_notification_options

    # Creating notification
    chrome.notifications.create("pattern_#{new Date().getTime()}", options, (id) -> )

  # ===================================
  # Event handlers
  # ===================================

  # Clicked on buttons
  # ===================================

  notification_button_clicked = (notif_id, button_index) ->
    if _pattern.indexOf('MULTI_ACTIVATE') == 0
      handle_ma_button_clicked(notif_id, button_index)
    else if _pattern.indexOf('COMPARE') == 0
      handle_compare_button_clicked(notif_id, button_index)
    else if _pattern.indexOf('REFRESH') == 0
      handle_refresh_button_clicked(notif_id, button_index)
    else if _pattern.indexOf('MULTI_CLOSE') == 0
      handle_mc_button_clicked(notif_id, button_index)

    # Clear notifications
    chrome.notifications.clear(notif_id, (cleared) ->)

  # Per pattern handlers
  # ===================================

  handle_ma_button_clicked = (notif_id, button_index) ->
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

  handle_compare_button_clicked = (notif_id, button_index) ->
    # Pattern notification
    if notif_id.indexOf('pattern') == 0
      if button_index == 0
        send_resolution('YES')
      else if button_index == 1
        send_resolution('NO')

  handle_refresh_button_clicked = (notif_id, button_index) ->
    # Pattern notification
    if notif_id.indexOf('pattern') == 0
      if button_index == 0
        send_resolution('YES')
      else if button_index == 1
        send_resolution('NO')

  handle_mc_button_clicked = (notif_id, button_index) ->
    # Pattern notification
    if notif_id.indexOf('pattern') == 0
      if button_index == 0
        send_resolution('YES')
      else if button_index == 1
        send_resolution('NO')

  # Clicking on non button area (accept)
  # ===================================

  notification_clicked = (notif_id) ->
    if notif_id.indexOf('pattern') == 0
      send_resolution('ACCEPTED')
      _executor.execute(_pattern)
      show_revert()
    else if notif_id.indexOf('revert') == 0
      send_resolution('REVERTED')
      _executor.revert(_pattern)

    # Clear notifications
    chrome.notifications.clear(notif_id, (cleared) ->)

  # Closing notification using the x (reject)
  # ===================================

  notification_closed = (notif_id, by_user) ->
    if by_user && notif_id.indexOf('pattern') == 0
      send_resolution('REJECTED')

  # ===================================
  # Helper functions
  # ===================================

  send_resolution = (resolution) ->
    _conn.create_rec_log(
      pattern: _pattern
      resolution: resolution
      user_id: _uid
    )
