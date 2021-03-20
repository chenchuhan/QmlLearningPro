import QtQuick          2.12
import QtQuick.Window   2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts  1.12

ApplicationWindow {
    visible:                        true
    width:                          480
    height:                         360
    title:                          qsTr("基于Button定制的工具栏/目录")
    minimumWidth:                   450
    minimumHeight:                  240
    property int index:             1

    header: ToolBar {
        id:                         tabBar
        RowLayout {
            id:                     rowLayout
            anchors.fill:           parent
            spacing:                10
            //head
            ColoredImage {
                id:                 innerImage
                width:              30
                height:             width
                source:             "/images/menu"
                color:              "black"
            }
            //first Button
            MyButton {
                id:                 firstButton
                text:               qsTr("我是目录1")
                icon.source:        "/images/1"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 1
                }
            }
            //second Button
            MyButton {
                text:               qsTr("我是目录2")
                icon.source:        "/images/2"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 2
                }
            }
            //third Button
            MyButton {
                text:               qsTr("我是目录3")
                icon.source:        "/images/3"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 3
                }
            }
        }
    }

    Component.onCompleted: {
        firstButton.checked = true
    }

    function clearAllChecks() {
        for (var i=0; i<rowLayout.children.length; i++) {
           if (rowLayout.children[i].toString().startsWith("MyButton"))
                rowLayout.children[i].checked = false
            }
    }

    //界面的显示的形式有多种多样的，这里不做多说明。如前三个用的SwipeView。
    Loader {
        id:             firstPage
        anchors.fill:   parent
        visible:        index==1
        source:         "TestPage1.qml"
    }
    Loader {
        id:             secondPage
        anchors.fill:   parent
        visible:        index==2
        source:         "TestPage2.qml"
    }
    TestPage3 {
        id:             thirdPage
        anchors.fill:   parent
        visible:        index==3
    }
}
