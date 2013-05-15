chrome.browserAction.onClicked.addListener (tab) ->
    chrome.tabs.create
        url:chrome.extension.getURL("index.html")

oauth = ChromeExOAuth.initBackgroundPage
    request_url: 'https://www.google.com/accounts/OAuthGetRequestToken',
    authorize_url: 'https://www.google.com/accounts/OAuthAuthorizeToken',
    access_url: 'https://www.google.com/accounts/OAuthGetAccessToken',
    consumer_key: 'anonymous',
    consumer_secret: 'anonymous',
    scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.google.com/reader/api https://www.googleapis.com/auth/drive.file',
    app_name: 'gReader'
