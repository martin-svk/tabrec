'use strict'

# ======================================
# @author Martin Toma
#
# This class is used to log information
# about parallel browsing (tab) usage.
# It interacts with UsageLog table in API.
# ======================================

class @UsageLogger
  _bsize = Constants.get_batch_size()
  _dbg_mode = Constants.is_debug_mode()
  _parser = document.createElement('a')
  _conn = new Connection()
  _sha1 = new Hashes.SHA1()
  _uid = null
  _sid = null

  constructor: (user_id, session_id) ->
    _uid = user_id
    _sid = session_id

  # ===================================
  # Public methods
  # ===================================

  start: () ->
    console.log("Usage logger has started!") if _dbg_mode
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
    console.log("Caching usage log: User id: #{log.user_id}, Tab id: #{log.tab_id}, Event: #{log.event}, Time: #{log.timestamp}") if _dbg_mode
    _cache.push log
    if (_cache.length >= _bsize) || (get_current_ts() - _last_post_time > (2 * 60 * 1000))
      post_usage_logs()

  post_usage_logs = () ->
    # Clone of cache send to connection
    _conn.post_usage_logs(_cache.slice(0))
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
    _parser.href = tab.url
    _subdomain = _parser.hostname
    _domain = get_domain(_subdomain)
    _path = _parser.pathname
    console.log("Subdomain: #{_subdomain} domain: #{_domain} path: #{_path} url: #{_parser.href}") if _dbg_mode

    # Creating data object to POST
    cache_usage_log({
      user_id: _uid
      session_id: _sid
      timestamp: get_current_ts()
      event: 'TAB_CREATED'
      window_id: tab.windowId
      tab_id: tab.id
      url: _sha1.hex(_parser.href)
      domain: _sha1.hex(_domain)
      subdomain: _sha1.hex(_subdomain)
      path: _sha1.hex(_path)
    })

  tab_removed = (tab_id, remove_info) ->
    cache_usage_log({
      user_id: _uid
      session_id: _sid
      timestamp: get_current_ts()
      event: 'TAB_REMOVED'
      window_id: remove_info.windowId
      tab_id: tab_id
    })

  tab_activated = (active_info) ->
    chrome.tabs.get active_info.tabId, (tab) ->
      cache_usage_log({
        user_id: _uid
        session_id: _sid
        timestamp: get_current_ts()
        event: 'TAB_ACTIVATED'
        window_id: active_info.windowId
        tab_id: active_info.tabId
      })

  tab_moved = (tab_id, move_info) ->
    cache_usage_log({
      user_id: _uid
      session_id: _sid
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
      session_id: _sid
      timestamp: get_current_ts()
      event: 'TAB_ATTACHED'
      window_id: attach_info.newWindowId
      tab_id: tab_id
      index_to: attach_info.newPosition
    })

  tab_detached = (tab_id, detach_info) ->
    cache_usage_log({
      user_id: _uid
      session_id: _sid
      timestamp: get_current_ts()
      event: 'TAB_DETACHED'
      window_id: detach_info.oldWindowId
      tab_id: tab_id
      index_from: detach_info.oldPosition
    })

  tab_updated = (tab_id, change_info, tab) ->
    if change_info.status == 'complete'

      # URL splitting and hashing
      _parser.href = tab.url
      _subdomain = _parser.hostname
      _domain = get_domain(_subdomain)
      _path = _parser.pathname
      console.log("Subdomain: #{_subdomain} domain: #{_domain} path: #{_path} url: #{_parser.href}") if _dbg_mode

      # Creating data object to POST
      cache_usage_log({
        user_id: _uid
        session_id: _sid
        timestamp: get_current_ts()
        event: 'TAB_UPDATED'
        window_id: tab.windowId
        tab_id: tab.id
        url: _sha1.hex(_parser.href)
        domain: _sha1.hex(_domain)
        subdomain: _sha1.hex(_subdomain)
        path: _sha1.hex(_path)
      })
