import QtQuick          2.12
import QtQuick.Window   2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ApplicationWindow  {
    visible: true
    width:                      480
    height:                     360

//    title:            qsTr("TabBar工具栏/目录")
//    title:            qsTr("MenuBar菜单 + TabBar工具栏")
    title:            qsTr("ToolBar工具栏/目录")

    //[ToolBar修改]1: 替换header
    /*  ///--1 TabBar工具栏
    header: TabBar {
        id:             tabBar
        TabButton { text: qsTr("我是目录1") }
        TabButton { text: qsTr("我是目录2") }
        TabButton { text: qsTr("我是目录3") }
    }
    */

    ///--2.ToolBar
    header: ToolBar {
        id:     toolBar
        RowLayout {
            id:     rowLayout
            anchors.fill: parent
            ToolButton {
                text: qsTr("目录0")
                onClicked: view.currentIndex = 0
            }
            ToolButton {
                text: qsTr("目录1")
                onClicked: view.currentIndex = 1
            }
            ToolButton {
                text: qsTr("目录2")
                onClicked: view.currentIndex = 2
            }
        }
    }


    SwipeView {
        id: view
        anchors.fill: parent
        //[ToolBar修改]2: CurrentIndex的触发条件
//        currentIndex: tabBar.currentIndex
        onCurrentIndexChanged: {
//            tabBar.currentIndex = currentIndex
            for (var i=0; i<rowLayout.children.length; i++) {
                rowLayout.children[i].checked = false
            }
            rowLayout.children[currentIndex].checked = true

            indicator.currentIndex = currentIndex
        }
        //第一页
        Image {
            id:                 firstPage
            smooth:             true
            mipmap:             true
            antialiasing:       true
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            source:             "/images/code"
        }
        //第二页
        Image {
            id:                 secondPage
            smooth:             true
            mipmap:             true
            antialiasing:       true
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            source:             "/images/working"
        }
        //第三页
        Image {
            id:                 thirdPage
            smooth:             true
            mipmap:             true
            antialiasing:       true
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            source:             "/images/focus"
        }
    }
    PageIndicator {
        id: indicator
        count: view.count
        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }


    ///--MenuBar菜单
    /*//不用 "menuBar:" 就不会固定在header的上方
    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open...") }
            Action { text: qsTr("&Save") }
            Action { text: qsTr("Save &As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            MenuItem {
                text: "Cut"
                //快捷键，QtQuick.Controls 2.0后没有了，当然可以用其他方式实现
//                shortcut: "Ctrl+X"
                onTriggered: {}
            }
            MenuItem { text: "Copy" }
            MenuItem { text: "Paste" }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }
    */

}
