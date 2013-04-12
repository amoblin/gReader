
bp = chrome.extension.getBackgroundPage()

OAUTHURL    =   'https://accounts.google.com/o/oauth2/auth?'
VALIDURL    =   'https://www.googleapis.com/oauth2/v1/tokeninfo?access_token='
SCOPE       =   'https://www.googleapis.com/auth/userinfo.profile https://www.google.com/reader/api'
#CLIENTID    =   '640115812452.apps.googleusercontent.com'
CLIENTID    =   '640115812452-mk9muia2ldjp601bumj3mtiaemoce0qc.apps.googleusercontent.com'
REDIRECT    =   'http://reader.marboo.biz'
LOGOUT      =   'http://accounts.google.com/Logout'
TYPE        =   'token'
_url        =   OAUTHURL + 'scope=' + SCOPE + '&client_id=' + CLIENTID + '&redirect_uri=' + REDIRECT + '&response_type=' + TYPE
acToken = ""
tokenType = ""
expiresIn = ""
user = ""
loggedIn    =   false

login = () ->
    win         =   window.open(_url, "windowname1", 'width=800, height=600')

    pollTimer   =   window.setInterval () ->
        try
            console.log win.document.URL
            if win.document.URL.indexOf(REDIRECT) != -1
                window.clearInterval(pollTimer)
                url =   win.document.URL
                acToken =   gup(url, 'access_token')
                tokenType = gup(url, 'token_type')
                expiresIn = gup(url, 'expires_in')
                win.close()

                validateToken(acToken)
        catch e
            console.log(e)
    , 500

validateToken = (token) ->
    $.ajax
        url: VALIDURL + token,
        data: null,
        success: (responseText) ->
            getUserInfo()
            loggedIn = true
            $('#loginText').hide()
            $('#logoutText').show()
            getSubscription()
        dataType: "jsonp"

getSubscription = () ->
    $.ajax
        url: 'https://www.google.com/reader/api/0/subscription/list?output=json'
    .done (data) ->
        console.log(data)

getUserInfo = () ->
    $.ajax
        url: 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=' + acToken,
        data: null,
        success: (resp) ->
            user    =   resp
            console.log(user)
            $('#uName').text('Welcome ' + user.name)
            $('#imgHolder').attr('src', user.picture)
        ,
        dataType: "jsonp"

# credits: http://www.netlobo.com/url_query_string_javascript.html
gup = (url, name) ->
    name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]")
    regexS = "[\\#&]"+name+"=([^&#]*)"
    regex = new RegExp( regexS )
    results = regex.exec( url )
    if( results == null )
        return ""
    else
        return results[1]

startLogoutPolling = () ->
    $('#loginText').show()
    $('#logoutText').hide()
    loggedIn = false
    $('#uName').text('Welcome ')
    $('#imgHolder').attr('src', 'none.jpg')


# use by chrome extension

importFromGoogleReader = (subscriptions) ->
    local_subscriptions = JSON.parse(localStorage.getItem("subscriptions")) || []
    feed_ul = $("#sub-tree-item-0-main ul:first")
    tmp_dict = {}
    for item in subscriptions
        folders = []
        item.type = "rss"
        item.feedUrl = item.id.substring(5)

        wrap_fun = (item, folders) ->
            domainName = item.htmlUrl.split("/")[2]
            url = "http://" + domainName + "/favicon.ico"
            saveFavicon url, domainName, (faviconUrl) ->
                item.favicon = faviconUrl
                getJsonFeed url, (feed) -> localStorage.setItem(url, JSON.stringify(feed))

                for folder in folders
                    folder.append(generateFeed(item))
                local_subscriptions.push(item)
                localStorage.setItem("subscriptions", JSON.stringify(local_subscriptions))

        if item.categories.length == 0
            folders.push(feed_ul)
        else
            for cate in item.categories
                folder = ""
                if tmp_dict[cate.label] == undefined
                    folder =
                        type: "folder"
                        title: cate.label
                        item: []
                    local_subscriptions.push(folder)
                    localStorage.setItem("subscriptions", JSON.stringify(local_subscriptions))
                    tmp_dict[folder.title] = folder
                else
                    folder = tmp_dict[cate.label]

                folder.item.push(item)

                folder_li = generateFolder(folder)
                feed_ul.append(folder_li)

                folders.push(folder_li.find("ul:first"))

        wrap_fun(item, folders)

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
