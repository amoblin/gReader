#document.getElementById("lhn-add-subscription").onclick = 
feeds = {}

showAdd = () ->
    document.getElementById("quick-add-bubble-holder").setAttribute("class", "show")

showContent = (obj) ->
    v = $(obj).attr("title")
    feed = feeds[v]
    $("#viewer-header-container").css("display", "block")
    $("#viewer-entries-container").css("display", "block")
    $("#viewer-page-container").css("display", "none")
    div = $('<div class="entry entry-0"><div class="collapsed"><div class="entry-icons"><div class="item-star star link unselectable empty"></div></div><div class="entry-date">2013-3-31</div><div class="entry-main"><a class="entry-original" target="_blank" href="http://item.feedsky.com/~feedsky/MacGG/~7240343/727092688/5349783/1/item.html"></a><span class="entry-source-title">Mac GG</span><div class="entry-secondary"><h2 class="entry-title">[Mac]My Alarm Clock 1.5.2 – 『Mac 闹钟工具』</h2><span class="entry-secondary-snippet"> - <span class="snippet">My Alarm Clock 让您最喜爱的iPod音乐伴您每天醒来和入睡,获得您自己的多款专享设计师时钟,了解 [...]</span></span></div></div></div></div>')
    $("#entries").append(div)

addFeed = () ->
    v = $("#quickadd").val()
    $.ajax({
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&callback=?&q=' + encodeURIComponent(v),
        dataType: 'json',
        success: (data) ->
            feed = data.responseData.feed
            feeds[v] = feed
            li = $(sprintf('<li class="sub unselectable expanded unread">\n<div class="toggle sub-toggle toggle-d-2 hidden"></div>\n<a class="link" title="%s">\n <div style="background-image: url(//s2.googleusercontent.com/s2/favicons?domain=blog.sina.com.cn&amp;alt=feed)" class="icon sub-icon icon-d-2 favicon">\n </div>\n <div class="name-text sub-name-text name-text-d-2 name sub-name name-d-2 name-unread">%s</div>\n <div class="unread-count sub-unread-count unread-count-d-2"></div>\n <div class="tree-item-action-container">\n <div class="action tree-item-action section-button section-menubutton goog-menu-button"></div>\n </div>\n </a>\n </li>', v, feed.title))
            li.find("a:first").click -> showContent(this)
            $("#sub-tree-item-0-main ul:first").append(li)
            document.getElementById("quick-add-bubble-holder").setAttribute("class", "hidden")
    })

document.addEventListener 'DOMContentLoaded', () ->
    document.getElementById("lhn-add-subscription").addEventListener('click', showAdd)
    document.getElementById("add-feed").addEventListener('click', addFeed)
