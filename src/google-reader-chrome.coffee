
bp = chrome.extension.getBackgroundPage()

callback = (resp, xhr) ->
    importFromGoogleReader(JSON.parse(xhr.response).subscriptions)

onAuthorized = () ->
    url = 'https://www.google.com/reader/api/0/subscription/list'
    request =
        method: 'GET',
        parameters: {'output': 'json'}

    #发送：GET https://www.google.com/reader/api/0/subscription/list?output=json
    bp.oauth.sendSignedRequest(url, callback, request)

login2 = () ->
    bp.oauth.authorize(onAuthorized)
