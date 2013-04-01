chrome.browserAction.onClicked.addListener (tab) ->
    return chrome.tabs.create {
        url:chrome.extension.getURL("index.html")
    }

