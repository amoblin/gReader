
debug_var = ""

OAUTHURL    =   'https://accounts.google.com/o/oauth2/auth?'
VALIDURL    =   'https://www.googleapis.com/oauth2/v1/tokeninfo?access_token='
SCOPE       =   'https://www.googleapis.com/auth/userinfo.profile https://www.google.com/reader/api'
CLIENTID    =   '640115812452.apps.googleusercontent.com'
#CLIENTID    =   '640115812452-mk9muia2ldjp601bumj3mtiaemoce0qc.apps.googleusercontent.com'
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
    $.getJSON
        url: 'https://www.google.com/reader/api/0/subscription/list?output=json'
        dataType: "jsonp"
    .done (data) ->
        console.lgo("******")
        console.log(data)
        importFromGoogleReader(JSON.parse(data).subscriptions)

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

