# gReader

gReader - Google Reader的移植版。

在线使用： http://reader.marboo.io

gReader for Chrome Extension: <http://marboo.googlecode.com/files/gReader_v0.1.crx>

打算在Google Reader关闭之前把它的功能完全移植，目前我和 @greatghaul 两人开发。时间有限，精力不够，希望集众人之智，早日完成。

## 目前已实现的功能：

* 导入本地订阅文件subscriptions.xml
* 添加一条订阅
* 离线浏览（使用localStorage存储）
* 导入Google Reader 订阅（Web版暂不支持）
* 快捷键支持：f,j,k

## TODO List

* 时间显示
* 导入star items
* 同步阅读状态(使用Google Driver)
* 搜索

## 新功能

* 三栏视图


## For Developer

Google Reader UI 开发备忘

Button

```html
    <div role="button" class="jfk-button jfk-button-standard">
```

Button:hover

    <div role="button" class="jfk-button jfk-button-standard jfk-button-hover">

下拉菜单

    <div role="button" class="goog-inline-block goog-flat-menu-button goog-flat-menu-button-collapse-left">

