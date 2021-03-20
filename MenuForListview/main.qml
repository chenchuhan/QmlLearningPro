import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Window {
    id:                         root
    visible:                    true
    width:                      480
    height:                     360
    minimumWidth:               450
    minimumHeight:              240
    title:                      qsTr("ListView菜单/工具栏")

    property int    pageIndex:          0
    property bool   fullMenuShow:       false
    property real   menuWidthShort:     40

    //三个图片界面：
    Item {
        id: page
        height:                 parent.height
        anchors.left:           parent.left
        anchors.leftMargin:     40
        anchors.right:          parent.right
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

    //左侧工具栏/目录的外框
    Rectangle {
        id:                     rectMenu
        width:                  fullMenuShow ? 40*4 : 40
        height:                 parent.height
        anchors.left:           parent.left
        anchors.top:            parent.top
        color:                  "gray"

        MouseArea {
            anchors.fill:       parent
            hoverEnabled:       true
            onEntered:          fullMenuShow = true
            onExited:           fullMenuShow = false
        }
//        Behavior on width {
//            NumberAnimation { duration: 200 }
//        }
    }

    //左侧工具栏/目录
    ListviewMenu {
        id:                     listViewMenu
        width:                  rectMenu.width
        listViewIndex:          0;
        color:                  "gray"

        listModel:   [
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

        onListIndex: { //使用信号连接器都可以
            pageIndex = idx;
        }

//        ///--信号连接器
//        Connections {
//            target:             repeaterMenu
//            onPageSig : {
//                pageIndex = idx //idx为pageSig信号的输入参数
//            }
//        }
    }
}
