'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to log information
# about parallel browsing (tab) usage.
# It interacts with UsageLog table in API.
# ======================================

class @UsageLogger
  _conn = null
  _dbg = false
  _batch_size = 100
  _uid = null

  constructor: (@connection, @batch_size, @user_id, @debug_mode) ->
    _conn = @connection
    _dbg = @debug_mode
    _batch_size = @batch_size
    _uid = @user_id

  # ===================================
  # Public methods
  # ===================================

  start: () ->
    console.log("Usage logger has started!") if _dbg
    chrome.tabs.onCreated.addListener(tab_created)
    chrome.tabs.onRemoved.addListener(tab_removed)
    chrome.tabs.onActivated.addListener(tab_activated)
    chrome.tabs.onMoved.addListener(tab_moved)
    chrome.tabs.onAttached.addListener(tab_attached)
    chrome.tabs.onDetached.addListener(tab_detached)
    chrome.tabs.onUpdated.addListener(tab_updated)

  # ===================================
  # Private vars
  # ===================================
  cache = []
  last_post_time= new Date().getTime()

  # ===================================
  # Private functions
  # ===================================

  cache_usage_log = (log) ->
    console.log("Caching usage log: Tab id: #{log.tab_id}, Event: #{log.event}, Time: #{log.timestamp}") if _dbg
    cache.push log
    if (cache.length >= _batch_size) || (get_current_ts() - last_post_time > (3 * 60 * 1000))
      post_usage_logs()

  post_usage_logs = () ->
    _conn.post_usage_logs(cache)
    cache.length = 0
    last_post_time = get_current_ts()


  get_current_ts = () ->
    new Date().getTime()

  # ===================================
  # Event handlers
  # ===================================

  tab_created = (tab) ->
    cache_usage_log({
      user_id: _uid
      timestamp: get_current_ts()
      event: 'TAB_CREATED'
      window_id: tab.windowId
      tab_id: tab.id
      url: tab.url
    })

  tab_removed = (tab_id, remove_info) ->
    cache_usage_log({
      user_id: _uid
      timestamp: get_current_ts()
      event: 'TAB_REMOVED'
      window_id: remove_info.windowId
      tab_id: tab_id
    })

  tab_activated = (active_info) ->
    chrome.tabs.get active_info.tabId, (tab) ->
      cache_usage_log({
        user_id: _uid
        timestamp: get_current_ts()
        event: 'TAB_ACTIVATED'
        window_id: active_info.windowId
        tab_id: active_info.tabId
        url: tab.url
      })

  tab_moved = (tab_id, move_info) ->
    cache_usage_log({
      user_id: _uid
      timestamp: get_current_ts()
      event: 'TAB_MOVED'
      window_id: move_info.windowId
      tab_id: tab_id
      index_from: move_info.fromIndex
      index_to: move_info.toIndex
    })

  tab_attached = (tab_id, attach_info) ->
    cache_usage_log({
      user_id: _uid
      timestamp: get_current_ts()
      event: 'TAB_ATTACHED'
      window_id: attach_info.newWindowId
      tab_id: tab_id
      index_to: attach_info.newPosition
    })

  tab_detached = (tab_id, detach_info) ->
    cache_usage_log({
      user_id: _uid
      timestamp: get_current_ts()
      event: 'TAB_DETACHED'
      window_id: detach_info.oldWindowId
      tab_id: tab_id
      index_from: detach_info.oldPosition
    })

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'
      cache_usage_log({
        user_id: _uid
        timestamp: get_current_ts()
        event: 'TAB_UPDATED'
        url: tab.url
        window_id: tab.windowId
        tab_id: tab.id
      })
