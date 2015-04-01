chrome.runtime.onInstalled.addListener (details) ->
  if details.reason == 'install'
    chrome.tabs.create {
      url: chrome.runtime.getURL('options.html')
      active: true
    }
  else if details.reason == 'update'
    chrome.tabs.create {
      url: chrome.runtime.getURL('changelog.html')
      active: true
    }
