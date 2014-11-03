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

  constructor: (@connection) ->
    _conn = @connection

  # Public methods

  start: () ->
    console.log("Usage logger has started!")
    chrome.tabs.onCreated.addListener(tab_created)
    chrome.tabs.onRemoved.addListener(tab_removed)
    chrome.tabs.onActivated.addListener(tab_activated)

  # Private vars
  cache = []

  # Private functions
  cache_usage_log = (log) ->
    console.log("Caching usage log: Tab id: #{log.tab_id}, Event: #{log.event}, Time: #{log.timestamp}")
    cache.push log
    console.log("Cache size: #{cache.length}")
    if cache.length > 999
      post_usage_logs()

  post_usage_logs = () =>
    console.log("!!! Posting usage logs.")
    _conn.post_usage_logs(cache)
    cache.length = 0

  # Event handlers

  tab_created = (tab) ->
    cache_usage_log({
      tab_id: tab.id
      event: 'TAB_CREATE'
      timestamp: new Date().getTime()
    })

  tab_removed = (tab_id, remove_info) ->
    cache_usage_log({
      tab_id: tab_id
      event: 'TAB_REMOVE'
      timestamp: new Date().getTime()
    })

  tab_activated = (active_info) ->
    cache_usage_log({
      tab_id: active_info.tabId
      event: 'TAB_ACTIVATE'
      timestamp: new Date().getTime()
    })

