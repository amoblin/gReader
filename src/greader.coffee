
feeds = JSON.parse(localStorage.getItem("feeds")) || []
currentFeedURL = ""

generateOverview = () ->
  item = '
    <div class="overview-segment overview-stream" id="">
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
    folder = $(sprintf('<li class="folder unselectable collapsed unread" id="sub-tree-item-9-main">
                                            <div class="toggle folder-toggle toggle-d-1"></div>
                                            <a class="link" href="#"><div class="icon folder-icon icon-d-1" id="sub-tree-item-9-icon"></div><div class="name-text folder-name-text name-text-d-1 name folder-name name-d-1 name-unread" id="sub-tree-item-9-name">%s</div><div class="unread-count folder-unread-count unread-count-d-1" id="sub-tree-item-9-unread-count">(540)</div><div class="tree-item-action-container"><div id="sub-tree-item-9-action" class="action tree-item-action section-button section-menubutton goog-menu-button"></div></div></a>
                                            <ul></ul></li>', dict.title))
    ul = folder.find("ul:first")
    for item in dict.item
        ul.append(generateFeed(item.xmlUrl, item.title))
    folder.find(".folder-toggle").click -> toggle($(this).parent())
    return folder
    #feeds[k] = feed
    #storage.setItem("feeds", JSON.stringify(feeds))

showAdd = () ->
    $("#quick-add-bubble-holder").toggleClass("show")
    $("#quick-add-bubble-holder").toggleClass("hidden")

hideDetail = (obj, item) ->
    obj.removeClass("expanded")
    obj.find(".entry-container").remove()
    obj.find(".entry-actions").remove()
    obj.click -> showDetail(obj, item)

showDetail = (obj, item) ->
    obj.addClass("expanded")

    date = item.publishedDate
    link = item.link
    title = item.title
    desc = item.contentSnippet
    content = item.content

    entry_container = $(sprintf('<div class="entry-container"><div class="entry-main"><div class="entry-date">%s</div><h2 class="entry-title"><a class="entry-title-link" target="_blank" href="%s">%s<div class="entry-title-go-to"></div></a><span class="entry-icons-placeholder"></span></h2><div class="entry-author"><span class="entry-source-title-parent">来源：<a class="entry-source-title" target="_blank" href=""></a></span> </div><div class="entry-debug"></div><div class="entry-annotations"></div><div class="entry-body"><div><div class="item-body"><div>%s</div></div></div></div></div></div>', date, link, title, content))
    entry_actions = $('<div class="entry-actions"><span class="item-star star link unselectable" title="加注星标"></span><wbr><span class="item-plusone" style="height: 15px; width: 70px; display: inline-block; text-indent: 0px; margin: 0px; padding: 0px; background-color: transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline; background-position: initial initial; background-repeat: initial initial;"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" scrolling="no" style="position: absolute; top: -10000px; width: 70px; margin: 0px; border-style: none;" tabindex="0" vspace="0" width="100%" id="I6_1364822093465" name="I6_1364822093465" allowtransparency="true" data-gapiattached="true"></iframe></span><wbr><span class="email"><span class="link unselectable">电子邮件</span></span><wbr><span class="read-state-not-kept-unread read-state link unselectable" title="保持为未读状态">保持为未读状态</span><wbr><span></span><wbr><span class="tag link unselectable"><span class="entry-tagging-action-title">修改标签: </span><ul class="user-tags-list"><li><a href="/reader/view/user%2F-%2Flabel%2FIT.%E6%95%B0%E7%A0%81">IT.数码</a></li></ul></span></div>')
    obj.append(entry_container)
    obj.append(entry_actions)
    obj.click -> hideDetail(obj, item)

showContent = (feedURL) ->
    feed = JSON.parse(localStorage.getItem(feedURL))
    $("#entries").find(".entry").remove()
    i = 0
    for item in feed.entries

        dt = new Date(item.publishedDate)
        date = dt.toLocaleTimeString()

        link = item.link
        stitle = feed.title
        title = item.title
        desc = item.contentSnippet

        $("#viewer-header-container").css("display", "block")
        $("#viewer-entries-container").css("display", "block")
        $("#viewer-page-container").css("display", "none")
        div = $(sprintf('<div class="entry entry-%s read"><div class="collapsed"><div class="entry-icons"><div class="item-star star link unselectable empty"></div></div><div class="entry-date">%s</div><div class="entry-main"><a class="entry-original" target="_blank" href="%s"></a><span class="entry-source-title">%s</span><div class="entry-secondary"><h2 class="entry-title">%s</h2><span class="entry-secondary-snippet"> - <span class="snippet">%s</span></span></div></div></div></div>', i, date, link, stitle, title, desc))
        i += 1
        a = (obj, args) ->
            div.click -> showDetail(obj, args)
        a(div, item)

        $("#entries").append(div)
    $("#stream-prefs-menu").click -> showMenu(feedURL)
    currentFeedURL = feedURL

addFeed = () ->
    k = $("#quickadd").val()
    getJsonFeed k, (feed) ->
        localStorage.setItem(k, JSON.stringify(feed))

        li = generateFeed(feed.feedUrl, feed.title)
        $("#sub-tree-item-0-main ul:first").append(li)
        $("#quick-add-bubble-holder").toggleClass("show")
        $("#quick-add-bubble-holder").toggleClass("hidden")

        feeds.push({"title":feed.title, "type":"rss", "xmlUrl":feed.feedUrl})
        #feeds = JSON.parse(localStorage.getItem("feeds")) || {}
        localStorage.setItem("feeds", JSON.stringify(feeds))

getJsonFeed = (url, cb) ->
    $.ajax({
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=50&callback=?&q=' + encodeURIComponent(url),
        dataType: 'json',
        success: (data) ->
            feed = data.responseData.feed
            cb(feed)
    })

generateFeed = (url, title) ->
    li = $(sprintf('<li class="sub unselectable expanded unread">\n<div class="toggle sub-toggle toggle-d-2 hidden"></div>\n<a class="link" title="%s">\n <div style="background-image: url(img/a.png)" class="icon sub-icon icon-d-2 favicon">\n </div>\n <div class="name-text sub-name-text name-text-d-2 name sub-name name-d-2 name-unread">%s</div>\n <div class="unread-count sub-unread-count unread-count-d-2"></div>\n <div class="tree-item-action-container">\n <div class="action tree-item-action section-button section-menubutton goog-menu-button"></div>\n </div>\n </a>\n </li>', url, title))
    li.find("a:first").click -> showContent(url)
    return li

init = () ->
    feed_ul = $("#sub-tree-item-0-main ul:first")
    for item in feeds
        if item.type == "rss"
            feed_ul.append(generateFeed(item.xmlUrl, item.title))
        else
            feed_ul.append(generateFolder(item))

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
            <div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":bp">
                <div class="goog-menuitem-content"> 取消订阅</div>
            </div>
            <!--
            <div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":bq">
                <div class="goog-menuitem-content"> 重命名订阅...</div>
            </div>
            -->
            <div class="goog-menuseparator" style="-webkit-user-select: none;" role="separator" id=":br">
            </div>
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
            <div class="goog-menuitem goog-menuitem-disabled" role="menuitem" style="-webkit-user-select: none;" id=":bw">
                <div class="goog-menuitem-content">更改文件夹...</div>
            </div>
        </div>')
    dirMenu = $(sprintf('<div class="goog-menuitem goog-option-selected goog-option" role="menuitem" style="-webkit-user-select: none;" id=":bx">
                <div class="goog-menuitem-content"> <div class="goog-menuitem-checkbox"></div>%s</div></div>', "abc"))
    menu.append(dirMenu)
    menu.append($('<div class="goog-menuitem" role="menuitem" style="-webkit-user-select: none;" id=":cc">
                <div class="goog-menuitem-content">新文件夹...</div>
            </div>'))

    $("body").append(menu)
    $("#stream-prefs-menu").unbind("click")
    $("#stream-prefs-menu").click -> toggleMenu(menu)

toggleMenu = (menu) ->
    if menu.css("display") == "block"
        menu.css("display", "none")
    else
        menu.css("display", "block")

refreshFeed = () ->
    getJsonFeed currentFeedURL, (feed) ->
        localStorage.setItem(currentFeedURL, JSON.stringify(feed))
        showContent(currentFeedURL)

jQuery ->
    $("#lhn-add-subscription").click -> showAdd()
    $("#add-feed").click -> addFeed()
    $(".folder-toggle").click -> toggle($(this).parent())
    $("#viewer-refresh").click -> refreshFeed()

    init()

    # Auto fix height
#    auto_height = () ->
#      $section = $('#scrollable-sections')
#      $section.css height: $(window).height() - $section.offset().top - 10
#
#      $viewer  = $('#viewer-entries-container')
#      $viewer.css height: $(window).height() - $viewer.offset().top - 10
#
#    setInterval auto_height, 200
