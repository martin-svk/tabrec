'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to execute recommended
# action after user accepted it via notification
# ======================================

class @Executor
  _dbg_mode = null

  constructor: () ->
    _dbg_mode = Constants.is_debug_mode()

  execute: (pattern) ->
    console.log("Executing action for: #{pattern}") if _dbg_mode
    if pattern == 'MULTI_ACTIVATE'
      handle_multi_activate_pattern()

  # ===================================
  # Private functions
  # ===================================

  handle_multi_activate_pattern = () ->
    chrome.tabs.query(windowId: chrome.windows.WINDOW_ID_CURRENT, sort_tabs_by_domains)

  # ===================================
  # Helper functions
  # ===================================

  sort_tabs_by_domains = (tabs) ->
    _current_tabs = []

    for tab in tabs
      _current_tabs.push(
        id: tab.id
        domain: new URL(tab.url).hostname
      )

    # Sort current tabs by domains
    _current_tabs.sort (a, b) ->
      a.domain.localeCompare(b.domain)

    # Move them in browser accordingly
    ids = _current_tabs.map (tab) -> tab.id
    chrome.tabs.move(ids, index: 0)
