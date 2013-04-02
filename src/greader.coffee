#document.getElementById("lhn-add-subscription").onclick = 
storage = window.localStorage

#storage.setItem("feeds", "{}")
feeds = JSON.parse(storage.getItem("feeds")) || {}
storage.setItem("feeds", JSON.stringify(feeds))

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

generateFolder = () ->
    folder = '<li class="folder unselectable collapsed unread" id="sub-tree-item-9-main">
                                            <div class="toggle folder-toggle toggle-d-1"></div>
                                            <a class="link" href="#"><div class="icon folder-icon icon-d-1" id="sub-tree-item-9-icon"></div><div class="name-text folder-name-text name-text-d-1 name folder-name name-d-1 name-unread" id="sub-tree-item-9-name">job</div><div class="unread-count folder-unread-count unread-count-d-1" id="sub-tree-item-9-unread-count">(540)</div><div class="tree-item-action-container"><div id="sub-tree-item-9-action" class="action tree-item-action section-button section-menubutton goog-menu-button"></div></div></a>
                                            <ul>%s</ul></li>'

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

showContent = (obj) ->
    v = $(obj).attr("title")
    feed = feeds[v]
    i = 0
    $("#entries").find(".entry").remove()
    for item in feed.entries
        date = item.publishedDate
        link = item.link
        stitle = feed.title
        title = item.title
        desc = item.contentSnippet

        $("#viewer-header-container").css("display", "block")
        $("#viewer-entries-container").css("display", "block")
        $("#viewer-page-container").css("display", "none")
        div = $(sprintf('<div class="entry entry-%s read"><div class="collapsed"><div class="entry-icons"><div class="item-star star link unselectable empty"></div></div><div class="entry-date">%s</div><div class="entry-main"><a class="entry-original" target="_blank" href="%s"></a><span class="entry-source-title">%s</span><div class="entry-secondary"><h2 class="entry-title">%s</h2><span class="entry-secondary-snippet"> - <span class="snippet">%s</span></span></div></div></div></div>', i, date, link, stitle, title, desc))
        i = i + 1
        a = (obj, args) ->
            div.click -> showDetail(obj, args)
        a(div, item)

        $("#entries").append(div)

addFeed = () ->
    k = $("#quickadd").val()
    $.ajax({
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&callback=?&q=' + encodeURIComponent(k),
        dataType: 'json',
        success: (data) ->
            feed = data.responseData.feed
            feeds[k] = feed
            storage.setItem("feeds", JSON.stringify(feeds))

            li = generateFeed(feed)
            $("#sub-tree-item-0-main ul:first").append(li)
            $("#quick-add-bubble-holder").toggleClass("show")
            $("#quick-add-bubble-holder").toggleClass("hidden")
    })

generateFeed = (feed) ->
    li = $(sprintf('<li class="sub unselectable expanded unread">\n<div class="toggle sub-toggle toggle-d-2 hidden"></div>\n<a class="link" title="%s">\n <div style="background-image: url(images/a.png)" class="icon sub-icon icon-d-2 favicon">\n </div>\n <div class="name-text sub-name-text name-text-d-2 name sub-name name-d-2 name-unread">%s</div>\n <div class="unread-count sub-unread-count unread-count-d-2"></div>\n <div class="tree-item-action-container">\n <div class="action tree-item-action section-button section-menubutton goog-menu-button"></div>\n </div>\n </a>\n </li>', feed.feedUrl, feed.title))
    li.find("a:first").click -> showContent(this)
    return li

init = () ->
    for k, v of JSON.parse(storage.getItem("feeds"))
        li = generateFeed(v)
        $("#sub-tree-item-0-main ul:first").append(li)

toggle = (obj) ->
    obj.toggleClass("collapsed")
    obj.toggleClass("expanded")

document.addEventListener 'DOMContentLoaded', () ->
    document.getElementById("lhn-add-subscription").addEventListener('click', showAdd)
    document.getElementById("add-feed").addEventListener('click', addFeed)
    $(".folder-toggle").click -> toggle($(this).parent())
    init()
