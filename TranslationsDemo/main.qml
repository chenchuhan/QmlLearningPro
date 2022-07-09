import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

//import CC.QML 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Column {
        anchors.centerIn:  parent
        spacing:           15
//        Label {
//            text:  qsTr("Qml Test1")
//            font.pointSize: 15
//        }

        Label {
            text:  TranslationTest.globalGreeting(0)
            font.pointSize: 15
        }
        Label {
            text:  TranslationTest.globalGreeting(1)
            font.pointSize: 15
        }

//        Rectangle {
//            width:  parent.width
//            height: 2
//            color:  "red"
//        }

//        Repeater {
//            id:         repeater
//            model:      TranslationTest.qStringListTest
//            Label {
//                text:                       modelData
//                font.pointSize:             15
//                font.bold:                  true                     //黑体
//            }
//        }
    }
}
