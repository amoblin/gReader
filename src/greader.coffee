# vim: sw=4 ts=4
THREE_COLUMN_VIEW = 0
subscriptions = JSON.parse(localStorage.getItem("subscriptions")) || []
currentFeedUrl = ""
fs = ""
debug_var = ""
start_folder = "apple"

generateOverview = () ->
  item = '<div class="overview-segment overview-stream" id="">
      <div class="overview-header">
        <span class="title">
          <a class="sub-link" href="#" id="" target="_blank">LinuxTOY<span class="unread"><span class="unread">(31)</span></span></a>
        </span>
      </div>
      <img src="./gReader_files/linuxdeepin-12.12-beta-coming.jpg" width="161" height="66" alt="">
      <div class="overview-metadata" dir="ltr">
        <p class="link item-title overview-item-link" id="tag:google.com,2005:reader/item/7e99d3220c53e727">%s</p>
        <p class="item-snippet overview-item-link" id="tag:google.com,2005:reader/item/7e99d3220c53e727">%s</p>
      </div>
      <div class="label">
        <p>了解更多  <a class="label-link" id="overview-user/08003626058048695165/label/IT.数码" href="#" target="_blank">%s<span class="unread">(75)</span></a>  的信息</p>
      </div>
    </div>'

generateFolder = (dict) ->
    result = $("#sub-tree").find("li ul li a div:contains('#{dict.title}'):first")
    if result.length > 0
        return result.parent().parent()
    folder = $(sprintf('<li class="folder unselectable collapsed unread">
                                            <div class="toggle folder-toggle toggle-d-1"></div>
                                            <a class="link" href="#"><div class="icon folder-icon icon-d-1" id="sub-tree-item-9-icon"></div><div class="name-text folder-name-text name-text-d-1 name folder-name name-d-1 name-unread" id="sub-tree-item-9-name">%s</div><div class="unread-count folder-unread-count unread-count-d-1" id="sub-tree-item-9-unread-count"></div><div class="tree-item-action-container"><div id="sub-tree-item-9-action" class="action tree-item-action section-button section-menubutton goog-menu-button"></div></div></a>
                                            <ul></ul></li>', dict.title))
    ul = folder.find("ul:first")
    for item in dict.item
        ul.append(generateFeed(item))
    folder.find(".folder-toggle").click -> toggle($(this).parent())
    folder.find("a:first").click -> showFolderContent(dict)
    #storage.setItem(dict.title, JSON.stringify(dict))
    return folder

toggleAddBox = () ->
    btnOffset = $(@).offset()
    style =
      top: btnOffset.top + $(@).height()
      left: btnOffset.left
    $("#quick-add-bubble-holder").css(style).toggleClass('hidden')
    $('#quickadd').val('').focus()

toggleStar = (obj, item) ->
    obj.find(".entry-icons div").toggleClass("item-star")
    obj.find(".entry-icons div").toggleClass("item-star-active")

showDetail = (obj, item) ->
    obj.toggleClass("expanded")

    if obj.attr("id") != "current-entry"
        if $("#current-entry").hasClass("expanded")
            $("#current-entry").find("div:first").click()
        $("#current-entry").attr("id", "")
        obj.attr("id", "current-entry")

    if obj.find(".entry-container").length > 0
        obj.find(".entry-container").remove()
        obj.find(".entry-actions").remove()
        return

    date = item.publishedDate
    link = item.link
    title = item.title
    desc = item.contentSnippet
    content = item.content

    entry_container = $(sprintf('<div class="entry-container"><div class="entry-main"><div class="entry-date">%s</div><h2 class="entry-title"><a class="entry-title-link" target="_blank" href="%s">%s<div class="entry-title-go-to"></div></a><span class="entry-icons-placeholder"></span></h2><div class="entry-author"><span class="entry-source-title-parent">来源：<a class="entry-source-title" target="_blank" href=""></a></span> </div><div class="entry-debug"></div><div class="entry-annotations"></div><div class="entry-body"><div><div class="item-body"><div>%s</div></div></div></div></div></div>', date, link, title, content))
    entry_actions = $('<div class="entry-actions"><span class="item-star star link unselectable" title="加注星标"></span><wbr><span class="item-plusone" style="height: 15px; width: 70px; display: inline-block; text-indent: 0px; margin: 0px; padding: 0px; background-color: transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline; background-position: initial initial; background-repeat: initial initial;"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" scrolling="no" style="position: absolute; top: -10000px; width: 70px; margin: 0px; border-style: none;" tabindex="0" vspace="0" width="100%" id="I6_1364822093465" name="I6_1364822093465" allowtransparency="true" data-gapiattached="true"></iframe></span><wbr><span class="email"><span class="link unselectable">电子邮件</span></span><wbr><span class="read-state-not-kept-unread read-state link unselectable" title="保持为未读状态">保持为未读状态</span><wbr><span></span><wbr><span class="tag link unselectable"><span class="entry-tagging-action-title">修改标签: </span><ul class="user-tags-list"><li><a href="/reader/view/user%2F-%2Flabel%2FIT.%E6%95%B0%E7%A0%81">IT.数码</a></li></ul></span></div>')
    obj.append(entry_container)
    obj.append(entry_actions)

showContent = (feedUrl) ->
    feed = JSON.parse(localStorage.getItem(feedUrl))
    $("#entries").addClass("single-source")
    $("#entries").find(".entry").remove()
    $("#title-and-status-holder").css("display", "block")
    $("#chrome-title").html(sprintf('<a target="_blank" href="%s">%s<span class="chevron">»</span></a>', feed.link, feed.title))
    $("#chrome-view-links").css("display", "block")

    $("#stream-prefs-menu").click -> showMenu(feedUrl)
    currentFeedUrl = feedUrl
    generateContentList(feed.entries)

showFolderContent = (dict) ->
    $("#entries").removeClass("single-source")
    $("#entries").find(".entry").remove()
    $("#title-and-status-holder").css("display", "block")
    $("#chrome-title").html(dict.title)
    $("#chrome-view-links").css("display", "block")
    #entries = []
    for item in dict.item
        if localStorage.getItem(item.feedUrl) == null
            refreshFeed item.feedUrl, (feed, faviconUrl) ->
                generateContentList(feed.entries)
        else
            #entries.concat(JSON.parse(localStorage.getItem(item.feedUrl)).entries)
            entries = JSON.parse(localStorage.getItem(item.feedUrl)).entries
            generateContentList(entries)

generateContentList = (entries) ->
    i = 0
    for item in entries
        dt = new Date(item.publishedDate)
        date = dt.toLocaleTimeString()

        link = item.link
        stitle = item.stitle
        title = item.title
        desc = item.contentSnippet

        $("#viewer-header-container").css("display", "block")
        $("#viewer-entries-container").css("display", "block")
        $("#viewer-page-container").css("display", "none")
        div = $(sprintf('<div class="entry entry-%s ril_marked"><div class="collapsed"><div class="entry-icons"><div class="item-star star link unselectable empty"></div></div><div class="entry-date">%s</div><div class="entry-main"><a class="entry-original" target="_blank" href="%s"></a><span class="entry-source-title">%s</span><div class="entry-secondary"><h2 class="entry-title">%s</h2><span class="entry-secondary-snippet"> - <span class="snippet">%s</span></span></div></div></div></div>', i, date, link, stitle, title, desc))
        i += 1
        a = (obj, args) ->
            div.find(".collapsed").click -> showDetail(obj, args)
            div.find("div.entry-icons").click (e) ->
              toggleStar(obj, args)
              e.stopPropagation()

        a(div, item)

        $("#entries").append(div)

errorHandler = (e) ->
    msg = ""
    switch  e.code
        when FileError.QUOTA_EXCEEDED_ERR
            msg = 'QUOTA_EXCEEDED_ERR'
            break
        when FileError.NOT_FOUND_ERR
            msg = 'NOT_FOUND_ERR'
            break
        when FileError.SECURITY_ERR
            msg = 'SECURITY_ERR'
            break
        when FileError.INVALID_MODIFICATION_ERR
            msg = 'INVALID_MODIFICATION_ERR'
            break
        when FileError.INVALID_STATE_ERR
            msg = 'INVALID_STATE_ERR'
            break
        else
            msg = 'Unknown Error'
            break
    alert msg

addFeed = () ->
    url = $("#quickadd").val()
    if url.indexOf("http://") != 0
        alert "invalid feed url"
        return
    if localStorage.getItem(url)
        # TODO: Use google style flash messages instead of alert
        alert "You have subscribed to #{url}"
        return

    refreshFeed url, (feed, faviconUrl) ->
        f =
            title:   feed.title,
            type:    "rss",
            feedUrl: feed.feedUrl,
            favicon: faviconUrl
        li = generateFeed(f)
        $("#sub-tree-item-0-main ul:first").append(li)

        $("#quick-add-bubble-holder").toggleClass("show")
        $("#quick-add-bubble-holder").toggleClass("hidden")

        subscriptions.push(f)
        localStorage.setItem("subscriptions", JSON.stringify(subscriptions))

saveFavicon = (faviconUrl, domainName, cb) ->
    #$.get
    #    url: faviconUrl,
    #    dataType: 'blob',
    #    success: (data) ->
    #        #if this.status != 200 or xhr.response.size == 0
    #        #    saveFavicon("img/default.gif", domainName, cb)
    #        #else
    #        alert "succeed"

    xhr = new XMLHttpRequest()
    xhr.open('GET', faviconUrl, true)
    xhr.responseType = 'blob'

    xhr.onerror = () ->
        cb("img/default.gif")

    xhr.onreadystatechange = (e) ->
        if this.readyState < 4
            $("#loading-area-container").removeClass("hidden")
        else
            $("#loading-area-container").addClass("hidden")

    xhr.onload = (e) ->
        $("#loading-area-container").addClass("hidden")
        if this.status != 200 or xhr.response.size == 0
            saveFavicon("img/default.gif", domainName, cb)
        else
            fs.root.getFile domainName+".ico", {create: true}, (fileEntry) ->
                #fileEntry.isFile == true
                #fileEntry.name == 'log-f-api.txt'
                #fileEntry.fullPath == '/log-f-api.txt'
                fileEntry.createWriter (fileWriter) ->
                    fileWriter.onwriteend = (e) ->
                        cb(fileEntry.toURL())
                    fileWriter.onerror = (e) ->
                        console.log('Write failed:' + e.toString())
                    fileWriter.write(xhr.response)
                , errorHandler
            , errorHandler
    xhr.send()

getJsonFeed = (url, cb) ->
    #jQuery.getFeed({
    #    url: url,
    #    success: (feed) ->
    #        alert(feed.title)
    #})
    $("#loading-area-container").removeClass("hidden")
    $.ajax
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=50&callback=?&q=' + encodeURIComponent(url),
        dataType: 'json',
        success: (data) ->
            feed = data.responseData.feed
            for item in feed.entries
                item.stitle = feed.title
            cb(feed)
        complete: () ->
            $("#loading-area-container").addClass("hidden")

generateFeed = (feed) ->
    li = $(sprintf('<li class="sub unselectable expanded unread">\n<div class="toggle sub-toggle toggle-d-2 hidden"></div>\n<a class="link" title="%s">\n <div style="background-image: url(%s); background-size:16px 16px" class="icon sub-icon icon-d-2 favicon">\n </div>\n <div class="name-text sub-name-text name-text-d-2 name sub-name name-d-2 name-unread">%s</div>\n <div class="unread-count sub-unread-count unread-count-d-2"></div>\n <div class="tree-item-action-container">\n <div class="action tree-item-action section-button section-menubutton goog-menu-button"></div>\n </div>\n </a>\n </li>', feed.feedUrl, feed.favicon, feed.title))
    li.find("a:first").click ->
        if localStorage.getItem(feed.feedUrl) == null
            refreshFeed feed.feedUrl, (feed, faviconUrl) -> showContent(feed.feedUrl)
        else
            showContent(feed.feedUrl)
    return li

toggle = (obj) ->
    obj.toggleClass("collapsed")
    obj.toggleClass("expanded")

showMenu = (url) ->
    menu = $('<div class="goog-menu goog-menu-vertical subscription-folders-menu" style="-webkit-user-select: none; max-height: 291.5999984741211px; visibility: visible; left: 565.4000244140625px; top: 45.4000015258789px; display: block;" role="menu" aria-haspopup="true" tabindex="-1" aria-activedescendant="">
            <!--
            <div class="goog-menuitem goog-option-selected goog-option" role="menuitem" style="-webkit-user-select: none;" id=":bl">
                <div class="goog-menuitem-content">
                    <div class="goog-menuitem-checkbox">
                </div>最新条目在前</div>
            </div>
            <div class="goog-menuitem goog-option" role="menuitem" style="-webkit-user-select: none;" id=":bm">
                <div class="goog-menuitem-content">
                    <div class="goog-menuitem-checkbox">
                    </div>
                    最旧条目在前</div>
            </div>
            <div class="goog-menuitem goog-option" role="menuitem" style="-webkit-user-select: none;" id=":bn">
                <div class="goog-menuitem-content">
                    <div class="goog-menuitem-checkbox">
                    </div>
                    神奇排序</div>
            </div>
            <div class="goog-menuseparator" style="-webkit-user-select: none;" role="separator" id=":bo">
            </div>
            -->
            <!--
            <div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":bq">
                <div class="goog-menuitem-content"> 重命名订阅...</div>
            </div>
            -->
            <!--
            <div class="goog-menuitem goog-option" role="menuitem" style="-webkit-user-select: none;" id=":bs">
                <div class="goog-menuitem-content">
                    <div class="goog-menuitem-checkbox"></div>
                    翻译为我使用的语言
                </div>
            </div>
            <div class="goog-menuseparator" style="-webkit-user-select: none;" role="separator" id=":bt"></div>
            <div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":bu">
                <div class="goog-menuitem-content"> 查看明细和统计信息</div>
            </div>
            <div class="goog-menuitem goog-submenu" role="menuitem" style="-webkit-user-select: none;" aria-haspopup="true" id=":bv">
                <div class="goog-menuitem-content">
                    更多与此类似的供稿...<span class="goog-submenu-arrow">►</span>
                </div>
            </div>
            -->
        </div>')
    dirMenu = $('<div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":bp">
                <div class="goog-menuitem-content"> 取消订阅</div>
            </div>')
    dirMenu.on "click", removeFeed
    menu.append(dirMenu)
    menu.append($('<div class="goog-menuseparator" style="-webkit-user-select: none;" role="separator" id=":br"></div>'))
    menu.append($('<div class="goog-menuitem goog-menuitem-disabled" role="menuitem" style="-webkit-user-select: none;" id=":bw"><div class="goog-menuitem-content">更改文件夹...</div></div>'))
    dirMenu = $(sprintf('<div class="goog-menuitem goog-option-selected goog-option" role="menuitem" style="-webkit-user-select: none;" id=":bx">
                <div class="goog-menuitem-content"> <div class="goog-menuitem-checkbox"></div>%s</div></div>', "abc"))
    menu.append(dirMenu)
    menu.append($('<div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":cc">
                <div class="goog-menuitem-content">新文件夹...</div>
            </div>'))

    $("body").append(menu)
    $("#stream-prefs-menu").unbind "click"
    $("#stream-prefs-menu").click -> toggleMenu(menu)

removeFeed = () ->
    localStorage.removeItem(currentFeedUrl)
    for feed in subscriptions
        if feed.feedUrl == currentFeedUrl
            subscriptions.splice(subscriptions.indexOf(feed), 1)
            localStorage.setItem("subscriptions", JSON.stringify(subscriptions))
            $("#sub-tree-item-0-main ul:first li a[title='#{currentFeedUrl}']").parent().remove()
            $("#stream-prefs-menu").click()
            return

removeAllFeeds = () ->
    for feed in subscriptions
        localStorage.removeItem(feed.feedUrl)
    localStorage.setItem("subscriptions", "[]")

toggleMenu = (menu) ->
    if menu.css("display") == "block"
        menu.css("display", "none")
    else
        menu.css("display", "block")

refreshFeed = (feedUrl, cb) ->
    getJsonFeed feedUrl, (feed) ->
        localStorage.setItem(feedUrl, JSON.stringify(feed))

        domainName = feed.link.split("/")[2]
        url = "http://" + domainName + "/favicon.ico"
        saveFavicon url, domainName, (faviconUrl) ->
            cb(feed, faviconUrl)

importFromOpml = (evt) ->
    file = evt.target.files[0]
    reader = new FileReader()
    ul = $("#sub-tree-item-0-main ul:first")

    reader.onload =  (oFREvent) ->
        opml = $(oFREvent.target.result)
        opml.find(":first-child").remove()
        for outline_str in opml.children()
            outline = $(outline_str)

            f =
                title: outline.attr("title"),
                type: outline.attr("type") || "folder",
                feedUrl: outline.attr("xmlUrl"),

            if outline.attr("type") == "rss"
                wrap_fun = (outline, f) ->

                    domainName = outline.attr("htmlUrl").split("/")[2]
                    url = "http://" + domainName + "/favicon.ico"
                    saveFavicon url, domainName, (faviconUrl) ->
                        f.favicon = faviconUrl
                        getJsonFeed url, (feed) -> localStorage.setItem(url, JSON.stringify(feed))
                        ul.append(generateFeed(f))
                        subscriptions.push(f)
                        localStorage.setItem("subscriptions", JSON.stringify(subscriptions))
                wrap_fun(outline, f)
            else
                f.item = []
                folder = generateFolder(f)
                for sub_outline_str in outline.children()
                    sub_outline = $(sub_outline_str)
                    wrap_fun = (sub_outline, folder, f) ->
                        domainName = sub_outline.attr("htmlUrl").split("/")[2]
                        url = "http://" + domainName + "/favicon.ico"
                        saveFavicon url, domainName, (faviconUrl) ->
                            sub_f =
                                title: sub_outline.attr("title"),
                                type: sub_outline.attr("type") || "folder"
                                feedUrl: sub_outline.attr("xmlUrl"),
                                favicon: faviconUrl

                            f.item.push(sub_f)
                            ul = folder.find("ul:first")
                            ul.append(generateFeed(sub_f))
                    wrap_fun(sub_outline, folder, f)
                $("#sub-tree-item-0-main ul:first").append(folder)
                subscriptions.push(f)
                localStorage.setItem("subscriptions", JSON.stringify(subscriptions))

    reader.readAsText(file)

getFavicon = (url, cb) ->
    domainName = url.split("/")[2]
    fs.root.getFile domainName+".ico", {}, (fileEntry) ->
        cb(fileEntry.toURL())
    , errorHandler

toggleThreeColumnView = () ->
    if THREE_COLUMN_VIEW == 0
        THREE_COLUMN_VIEW = 1
        $("#3-column-css").removeAttr("disabled")
        auto_height()
    else
        THREE_COLUMN_VIEW = 0
        $("#3-column-css").attr("disabled", "disabled")

# Auto fix height
auto_height = () ->
    $section = $('#scrollable-sections')
    $section.css height: $(window).height() - $section.offset().top - 10

    $viewer = $('#viewer-entries-container')
    $viewer.css height: $(window).height() - $viewer.offset().top - 10

    if THREE_COLUMN_VIEW
        $('#current-entry .entry-container').css height: parseInt($viewer.css("height"))-20

importFromGoogleReader = (subs) ->
    debug_var = subs
    feed_ul = $("#sub-tree-item-0-main ul:first")
    tmp_dict = {}

    for item in subs
        folders = []
        item.type = "rss"
        item.feedUrl = item.id.substring(5)

        wrap_fun = (item, folders) ->
            if item.htmlUrl != undefined
                domainName = item.htmlUrl.split("/")[2]
            else
                domainName = item.feedUrl.split("/")[3]
            url = "http://" + domainName + "/favicon.ico"

            saveFavicon url, domainName, (faviconUrl) ->
                item.favicon = faviconUrl
                getJsonFeed url, (feed) -> localStorage.setItem(url, JSON.stringify(feed))

                for folder in folders
                    folder.append(generateFeed(item))
                subscriptions.push(item)
                localStorage.setItem("subscriptions", JSON.stringify(subscriptions))

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
                    subscriptions.push(folder)
                    localStorage.setItem("subscriptions", JSON.stringify(subscriptions))
                    tmp_dict[folder.title] = folder
                else
                    folder = tmp_dict[cate.label]

                folder.item.push(item)

                folder_li = generateFolder(folder)
                feed_ul.append(folder_li)

                folders.push(folder_li.find("ul:first"))

        wrap_fun(item, folders)

do ($ = jQuery) ->
    if chrome.extension
        $("#import-data-area").append('<input type="button" id="googleConnector" size="1" style="position:absolute;opacity:0;filter:alpha(opacity=0);z-index:1000"></input>')
        $a = $("<a>从Google Reader导入订阅</a>")
        $a.on "click", -> $("#googleConnector").click()
        $("#import-data-area").append($a)
        $("#googleConnector").on "click", login2
    else
        $("#import-data-area").append('<input type="file" name="opml-file" id="opml-file" size="40" style="position:absolute;opacity:0;filter:alpha(opacity=0);z-index:1000"></input>')
        $a = $("<a>从subscriptions.xml导入订阅</a>")
        $a.on "click", -> $("#opml-file").click()
        $("#import-data-area").append($a)
        $('#opml-file').change -> importFromOpml(event)

    # Navigate to settings page
    showSettingsPage = () ->
        tpl = '''
              <div>
                  <iframe id="settings-frame" name="settings-frame" src="settings.html" 
                          frameborder="0" scrolling="no" style="height: 600px;" class="loaded">
                  </iframe>
              </div>
              '''
        console.log tpl
        $("body").addClass("settings")
        $("body").append($(tpl))
        $("#nav").hide()
        $("#chrome").hide()

        # FIXME: Trigger hide menu event when menu item clicked.
        $("#settings-button-menu").hide()

    # Navigate content to reader
    window.showHomePage = () ->
        $('body').removeClass('settings')
        $('#settings-frame').hide()
        $('#nav').show()
        $('#chrome').show()

    # Event bindding for quick add
    $("#lhn-add-subscription").on 'click', toggleAddBox
    $('#quick-add-close').on 'click', toggleAddBox

    $("#add-feed").on 'click', addFeed
    $(".folder-toggle").click -> toggle($(this).parent())
    $("#viewer-refresh").click -> refreshFeed currentFeedUrl, (feed, favcionUrl) -> showContent(feed.feedUrl)
    $("#lhn-selectors-minimize").click -> $("#lhn-selectors").toggleClass("section-minimized")
    $("#lhn-recommendations-minimize").click -> $("#lhn-recommendations").toggleClass("section-minimized")
    $("#lhn-subscriptions-minimize").click -> $("#lhn-subscriptions").toggleClass("section-minimized")
    $("#chrome-view-links span div:eq(1)").on "click", toggleThreeColumnView

    # Setting menu event bindings
    $('.settings-button-container').on 'click', () -> $('#settings-button-menu').toggle()
    $("#settings-button-menu .goog-menuitem-settings").on 'click', showSettingsPage

    setInterval auto_height, 200

    # html5 file system
    window.requestFileSystem  = window.requestFileSystem || window.webkitRequestFileSystem
    if window.requestFileSystem
        window.requestFileSystem window.TEMPORARY, 100*1024*1024, (filesystem) ->
            fs = filesystem
        , errorHandler

    # build subscription tree
    feed_ul = $("#sub-tree-item-0-main ul:first")
    for item in subscriptions
        if item.type == "rss" and (item.categories == undefined || item.categories.length == 0)
            feed_ul.append(generateFeed(item))
        if item.type == "folder"
            f = generateFolder(item)
            feed_ul.append(f)
            if item.title == start_folder
                f.find("a:first").click()

    # 3-column view
    #
