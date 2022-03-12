import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4

Item {
    Row {
        anchors.horizontalCenter:   parent.horizontalCenter
        anchors.top:                parent.top
        anchors.topMargin:          20
        spacing:                    10
        Button {
            id:     btn1
            text:  "测试1"
            onClicked: {
                rootWindow.showPopupCenter(display1)

            }
        }
        Button {
            id:     btn2
            text:  "测试2"
            onClicked: {
                rootWindow.showPopupBottom(display2,btn2)
            }
        }
    }

    Component {
        id:     display1
        Rectangle {
            width:                  lab1.width*1.5
            height:                 lab1.height*5
            radius:                 height*0.2
            color:                  "#FF9D6F"
            border.width:           4
            border.color:           "black"
            Label {
                id:                 lab1
                anchors.centerIn:   parent
                font.bold:          true
                font.pointSize:     20
                text:               "测试界面1(居中)"
            }
        }
    }

    Component {
        id:     display2
        Rectangle {
            width:                  lab2.width*1.5
            height:                 lab2.height*5
            radius:                 height*0.2
            color:                  "#97CBFF"
            border.width:           4
            border.color:           "black"
            Label {
                id:                 lab2
                anchors.centerIn:   parent
                font.bold:          true
                font.pointSize:     20
                text:               "测试界面2(底部)"
            }
        }
    }
}
