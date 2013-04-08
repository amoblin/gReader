chrome.browserAction.onClicked.addListener (tab) ->
    #chrome.windows.create {
    #    url:chrome.extension.getURL("index.html"),
    #    type: "popup"
    #}
    chrome.tabs.create {
        url:chrome.extension.getURL("index.html")
    }
    #chrome.tabs.sendMessage tab.id, {greeting: "getInfo"}, (response) ->
    #    if response.divided
    #        chrome.windows.create {
    #            url:chrome.extension.getURL("index.html"),
    #            type: "popup"
    #        }
    #    else
    #        chrome.tabs.create {
    #            url:chrome.extension.getURL("index.html")
    #        }

