$ ->
  goHome = () ->
    chrome.tabs.update url: chrome.extension.getURL("index.html")

  $("#close-settings-link").on "click", goHome
