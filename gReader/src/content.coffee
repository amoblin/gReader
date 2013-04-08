divided = 0

document.onkeydown = (event) ->
    if event.keyCode == 91
        divided = 1

chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
    if (request.greeting == "getInfo")
        sendResponse {divided: divided}
    else
        sendResponse {}
