'use strict'

# ======================================
# @author Martin Toma
#
# this class is used to execute recommended
# action after user accepted it via notification
# ======================================

class @Executor
  _dbg_mode = null
  _tabs_backup = []

  constructor: () ->
    _dbg_mode = Constants.is_debug_mode()

  execute: (pattern) ->
    console.log("Executing action for: #{pattern}") if _dbg_mode
    if pattern == 'MULTI_ACTIVATE'
      handle_multi_activate_pattern()

  revert: (pattern) ->
    console.log("Reverting action for: #{pattern}") if _dbg_mode
    if pattern == 'MULTI_ACTIVATE'
      revert_multi_activate_pattern()

  # ===================================
  # Private functions
  # ===================================

  handle_multi_activate_pattern = () ->
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
      _tabs_ordered.push(
        id: tab.id
        domain: new URL(tab.url).hostname
      )
      _tabs_backup.push(
        id: tab.id
      )

    # Sort current tabs by domains
    _tabs_ordered.sort (a, b) ->
      a.domain.localeCompare(b.domain)

    # Move them in browser accordingly
    ids = _tabs_ordered.map (tab) -> tab.id
    chrome.tabs.move(ids, index: 0)
