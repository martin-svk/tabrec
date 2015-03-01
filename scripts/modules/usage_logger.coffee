'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to log information
# about parallel browsing (tab) usage.
# It interacts with UsageLog table in API.
# ======================================

class @UsageLogger
  conn = null
  dbg_mode = false
  bsize = 100
  uid = null
  sid = null
  parser = document.createElement('a')
  sha1 = new Sha1()

  constructor: (@connection, @batch_size, @user_id, @session_id, @debug_mode) ->
    conn = @connection
    dbg_mode = @debug_mode
    bsize = @batch_size
    uid = @user_id
    sid = @session_id

  # ===================================
  # Public methods
  # ===================================

  start: () ->
    console.log("Usage logger has started!") if dbg_mode
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
  _cache = []
  _last_post_time = new Date().getTime()

  # ===================================
  # Private functions
  # ===================================

  cache_usage_log = (log) ->
    console.log("Caching usage log: User id: #{log.user_id}, Tab id: #{log.tab_id}, Event: #{log.event}, Time: #{log.timestamp}") if dbg_mode
    _cache.push log
    if (_cache.length >= bsize) || (get_current_ts() - _last_post_time > (2 * 60 * 1000))
      post_usage_logs()

  post_usage_logs = () ->
    conn.post_usage_logs(_cache)
    _cache.length = 0
    _last_post_time = get_current_ts()

  get_current_ts = () ->
    new Date().getTime()

  get_domain = (subdomain) ->
    array = subdomain.split('.')
    top_level_domain = array.pop()
    "#{array.pop()}.#{top_level_domain}"

  # ===================================
  # Event handlers
  # ===================================

  tab_created = (tab) ->

    # URL splitting and hashing
    parser.href = tab.url
    _subdomain = parser.hostname
    _domain = get_domain(_subdomain)
    _path = parser.pathname
    console.log("Subdomain: #{_subdomain} domain: #{_domain} path: #{_path} url: #{parser.href}") if dbg_mode

    # Creating data object to POST
    cache_usage_log({
      user_id: uid
      session_id: sid
      timestamp: get_current_ts()
      event: 'TAB_CREATED'
      window_id: tab.windowId
      tab_id: tab.id
      url: sha1.process(parser.href)
      domain: sha1.process(_domain)
      subdomain: sha1.process(_subdomain)
      path: sha1.process(_path)
    })

  tab_removed = (tab_id, remove_info) ->
    cache_usage_log({
      user_id: uid
      session_id: sid
      timestamp: get_current_ts()
      event: 'TAB_REMOVED'
      window_id: remove_info.windowId
      tab_id: tab_id
    })

  tab_activated = (active_info) ->
    chrome.tabs.get active_info.tabId, (tab) ->
      cache_usage_log({
        user_id: uid
        session_id: sid
        timestamp: get_current_ts()
        event: 'TAB_ACTIVATED'
        window_id: active_info.windowId
        tab_id: active_info.tabId
      })

  tab_moved = (tab_id, move_info) ->
    cache_usage_log({
      user_id: uid
      session_id: sid
      timestamp: get_current_ts()
      event: 'TAB_MOVED'
      window_id: move_info.windowId
      tab_id: tab_id
      index_from: move_info.fromIndex
      index_to: move_info.toIndex
    })

  tab_attached = (tab_id, attach_info) ->
    cache_usage_log({
      user_id: uid
      session_id: sid
      timestamp: get_current_ts()
      event: 'TAB_ATTACHED'
      window_id: attach_info.newWindowId
      tab_id: tab_id
      index_to: attach_info.newPosition
    })

  tab_detached = (tab_id, detach_info) ->
    cache_usage_log({
      user_id: uid
      session_id: sid
      timestamp: get_current_ts()
      event: 'TAB_DETACHED'
      window_id: detach_info.oldWindowId
      tab_id: tab_id
      index_from: detach_info.oldPosition
    })

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'

      # URL splitting and hashing
      parser.href = tab.url
      _subdomain = parser.hostname
      _domain = get_domain(_subdomain)
      _path = parser.pathname
      console.log("Subdomain: #{_subdomain} domain: #{_domain} path: #{_path} url: #{parser.href}") if dbg_mode

      # Creating data object to POST
      cache_usage_log({
        user_id: uid
        session_id: sid
        timestamp: get_current_ts()
        event: 'TAB_UPDATED'
        window_id: tab.windowId
        tab_id: tab.id
        url: sha1.process(parser.href)
        domain: sha1.process(_domain)
        subdomain: sha1.process(_subdomain)
        path: sha1.process(_path)
      })
