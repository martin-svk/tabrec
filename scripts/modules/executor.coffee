'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to execute recommended
# action after user accepted it via notification
# ======================================

class @Executor
  _dbg_mode = null
  _tabs = []
  _tabs_backup = []

  constructor: () ->
    _dbg_mode = Constants.is_debug_mode()

  execute: (pattern) ->
    console.log("Executing action for: #{pattern}") if _dbg_mode
    if pattern.indexOf('MULTI_ACTIVATE') == 0
      handle_multi_activate_pattern()

  revert: (pattern) ->
    console.log("Reverting action for: #{pattern}") if _dbg_mode
    if pattern.indexOf('MULTI_ACTIVATE') == 0
      revert_multi_activate_pattern()

  # ===================================
  # Private functions
  # ===================================

  handle_multi_activate_pattern = () ->
    clear_arrays()
    chrome.tabs.query(windowId: chrome.windows.WINDOW_ID_CURRENT, sort_tabs_by_domains)

  revert_multi_activate_pattern = () ->
    ids = _tabs_backup.map (tab) -> tab.id
    chrome.tabs.move(ids, index: 0)

  # ===================================
  # Helper functions
  # ===================================

  # Sorting tabs by their domains
  # ===================================

  sort_tabs_by_domains = (tabs) ->
    _tabs_ordered = []

    for tab in tabs
      url = new URL(tab.url)
      _tabs.push(
        id: tab.id
        domain: get_domain(url.hostname)
        subdomain: url.hostname
      )
      _tabs_backup.push(
        id: tab.id
      )

    # Sort current tabs by domains
    _tabs_ordered = sort_by_domains(_tabs)

    # Move them in browser accordingly
    ids = _tabs_ordered.map (tab) -> tab.id
    chrome.tabs.move(ids, index: 0)

  sort_by_domains = (tabs) ->
    tabs.sort (a, b) ->
      if a.domain == b.domain
        a.subdomain.localeCompare(b.subdomain)
      else
        a.domain.localeCompare(b.domain)

  # Clear tab containers
  clear_arrays = () ->
    _tabs = []
    _tabs_backup = []

  get_domain = (subdomain) ->
    array = subdomain.split('.')
    top_level_domain = array.pop()
    "#{array.pop()}.#{top_level_domain}"
