$ ->
    goHome = () ->
        parent.$("body").toggleClass("settings")
        parent.$("#settings-frame").toggle()
        parent.$("#nav").toggle()
        parent.$("#chrome").toggle()

    $("#close-settings-link").on "click", goHome
