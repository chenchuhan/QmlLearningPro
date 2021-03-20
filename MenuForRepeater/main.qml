import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

//import "qrc:/qml/slider/SlidierMain.qml"

Window {
    visible:                        true
    width:                          480
    height:                         360
    title:                          qsTr("Repeater菜单/工具栏")
    minimumWidth:                   450
    minimumHeight:                  240
    property int pageIndex:         3

    //三个图片界面 + 主界面：
    Item {
        id: page
        height:                 parent.height
        anchors.left:           parent.left
        anchors.leftMargin:     40
        anchors.right:          parent.right
        //miantPage
        Text {
            id:                 mainPage
            anchors.centerIn:   parent
            text:               "我是主页"
            font.pointSize:     30
            font.bold:          true
            visible:            (pageIndex != 0) ||  (pageIndex != 1) ||  (pageIndex != 2)
        }
        //firstPage
        Image {
            id:                 firstPage
            anchors.fill:       parent
            smooth:             true
            mipmap:             true
            antialiasing:       true
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            source:             "/images/code"
            visible:            pageIndex == 0

        }
        //secondPage
        Image {
            id:                 secondPage
             anchors.fill:       parent
            smooth:             true
            mipmap:             true
            antialiasing:       true
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            source:             "/images/working"
            visible:            pageIndex == 1
        }
        //thirdPage
        Image {
            id:                 thirdPage
            anchors.fill:       parent
            smooth:             true
            mipmap:             true
            antialiasing:       true
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            source:             "/images/focus"
            visible:            pageIndex == 2
        }
    }

    Rectangle {
        id:                     rectMenu
        width:                  40
        height:                 parent.height
        anchors.left:           parent.left
        anchors.top:            parent.top
        color:                  "gray"
        border.color:           "black"
        border.width:           2
    }

    RepeaterMenu {
        id:                     repeaterMenu
        anchors.fill:           rectMenu
        maxWidth:               rectMenu.width
        maxHeight:              rectMenu.height

        listMode: [
            {
                name:           qsTr("我是目录1"),
                iconSource:     "/images/1.png",
            },
            {
                name:           qsTr("我是目录2"),
                iconSource:     "/images/2.png",
            },
            {
                name:           qsTr("我是目录3"),
                iconSource:     "/images/3.png",
            }
        ]

        ///--信号连接器
        Connections {
            target:             repeaterMenu
            onPageSig : {
                pageIndex = idx //idx为pageSig信号的输入参数
            }
        }
    }
}
