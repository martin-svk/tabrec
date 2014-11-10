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

  constructor: (@connection, @batch_size, @debug_mode) ->
    _conn = @connection
    _dbg = @debug_mode
    _batch_size = @batch_size

  # Public methods

  start: () ->
    console.log("Usage logger has started!") if _dbg
    chrome.tabs.onCreated.addListener(tab_created)
    chrome.tabs.onRemoved.addListener(tab_removed)
    chrome.tabs.onActivated.addListener(tab_activated)
    chrome.tabs.onMoved.addListener(tab_moved)

  # Private vars
  cache = []

  # Private functions
  cache_usage_log = (log) ->
    console.log("Caching usage log: Tab id: #{log.tab_id}, Event: #{log.event}, Time: #{log.timestamp}") if _dbg
    cache.push log
    if cache.length >= _batch_size
      post_usage_logs()

  post_usage_logs = () =>
    _conn.post_usage_logs(cache)
    cache.length = 0

  # Event handlers

  tab_created = (tab) ->
    cache_usage_log({
      timestamp: (new Date()).getTime() / 1000 | 0
      event: 'TAB_CREATED'
      window_id: tab.windowId
      tab_id: tab.id
    })

  tab_removed = (tab_id, remove_info) ->
    cache_usage_log({
      timestamp: (new Date()).getTime() / 1000 | 0
      event: 'TAB_REMOVED'
      window_id: remove_info.windowId
      tab_id: tab_id
    })

  tab_activated = (active_info) ->
    cache_usage_log({
      timestamp: (new Date()).getTime() / 1000 | 0
      event: 'TAB_ACTIVATED'
      window_id: active_info.windowId
      tab_id: active_info.tabId
    })

  tab_moved = (tab_id, move_info) ->
    cache_usage_log({
      timestamp: (new Date()).getTime() / 1000 | 0
      event: 'TAB_MOVED'
      window_id: move_info.windowId
      tab_id: tab_id
      index_from: move_info.fromIndex
      index_to: move_info.toIndex
    })

