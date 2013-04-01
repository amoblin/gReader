#document.getElementById("lhn-add-subscription").onclick = 
showAdd = () ->
    document.getElementById("quick-add-bubble-holder").setAttribute("class", "show")

addFeed = () ->
    v = $("#quickadd").val()
    $.ajax({
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&callback=?&q=' + encodeURIComponent(v),
        dataType: 'json',
        success: (data) ->
            feed = data.responseData.feed
            li = $(sprintf('<li class="sub unselectable expanded unread">\n<div class="toggle sub-toggle toggle-d-2 hidden"></div>\n<a class="link" href="/reader/view/feed/%s">\n <div style="background-image: url(//s2.googleusercontent.com/s2/favicons?domain=blog.sina.com.cn&amp;alt=feed)" class="icon sub-icon icon-d-2 favicon">\n </div>\n <div class="name-text sub-name-text name-text-d-2 name sub-name name-d-2 name-unread">%s</div>\n <div class="unread-count sub-unread-count unread-count-d-2"></div>\n <div class="tree-item-action-container">\n <div class="action tree-item-action section-button section-menubutton goog-menu-button"></div>\n </div>\n </a>\n </li>', v, feed.title))
            $("#sub-tree-item-0-main ul:first").append(li)
    })

document.addEventListener 'DOMContentLoaded', () ->
    document.getElementById("lhn-add-subscription").addEventListener('click', showAdd)
    document.getElementById("add-feed").addEventListener('click', addFeed)
