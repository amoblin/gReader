goHome = () ->
    $("body").toggleClass("settings")
    $("#settings-frame").toggle()
    $("#nav").toggle()
    $("#chrome").toggle()

$ ->
    $("#close-settings-link").on "click", goHome
