'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to log information
# about provided recommendations and
# its resutions (accepted/rejected/automatic)
# it interacts with Log table in API
# ======================================

class @Logger
  dbg_mode = Constants.is_debug_mode()
  conn = new Connection()
  uid = null
  sid = null

  constructor: (user_id, session_id) ->
    uid = user_id
    sid = session_id

  # ===================================
  # Public methods
  # ===================================

  start: () ->
    console.log("Rec logger has started!") if dbg_mode
    chrome.tabs.onCreated.addListener(tab_created)
    chrome.tabs.onRemoved.addListener(tab_removed)
    chrome.tabs.onActivated.addListener(tab_activated)
    chrome.tabs.onMoved.addListener(tab_moved)
    chrome.tabs.onAttached.addListener(tab_attached)
    chrome.tabs.onDetached.addListener(tab_detached)
    chrome.tabs.onUpdated.addListener(tab_updated)

  # ===================================
  # Event handlers
  # ===================================

  tab_created = (tab) ->
    console.log("tab created") if dbg_mode

  tab_removed = (tab_id, remove_info) ->
    console.log("tab removed") if dbg_mode

  tab_activated = (active_info) ->
    console.log("tab activated") if dbg_mode

  tab_moved = (tab_id, move_info) ->
    console.log("tab moved") if dbg_mode

  tab_attached = (tab_id, attach_info) ->
    console.log("tab attached") if dbg_mode

  tab_detached = (tab_id, detach_info) ->
    console.log("tab detached") if dbg_mode

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'
      console.log("tab updated") if dbg_mode

  # ===================================
  # Pattern recognizing
  # ===================================

  record_event = (event_name, time_occured) ->
    console.log("#{event_name} occured on #{time_occured}") if dbg_mode
