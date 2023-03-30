import QtQuick          2.12
import QtQuick.Window   2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts  1.3

import Communication.QmlFile 1.0

Window {
    id:     rootWindow
    visible: true
    width: 720
    height: 480
    title: qsTr("Hello World")

    /*左侧为输入输出框，发送接收控制
      右侧为连接列表，同一接口层
    */

    property int    index: 0
    //内部使用
    readonly property color textColor:      "#5B5B5B"//"#8E8E8E"     //4C  33  66 = 0.4*256
    readonly property color bgColor:        "#faead3"    //淡黄
    readonly property color themeColor:     "#a27e7e"    //淡酒红色
    readonly property color labelColor:     "black"
    readonly property real  _margin:         10

    /// 已连接的颜色 "#019858"
    property real           ccPointSize:        13
    property color          labelColorS:        "white"

    ///整体背景颜色 淡黄
    Rectangle {
        id:                 bgRect
        width:              parent.width
        height:             parent.height
        color:              bgColor
    }

    //左侧
    Column {
        id:                 leftCol
        anchors.margins:    _margin
        anchors.left:       parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing:            _margin
        ///左侧文本框颜色
        Rectangle {
            id:                 rcvRect
            height:             rootWindow.height * 0.45
            width:              rootWindow.width * 0.4
            radius:             _margin /2
            color:              textColor
            ScrollView {
                id: view
                anchors.fill: parent
                TextArea {
                    id:                 rcvTextArea
                    cursorVisible: true;
                    focusReason:        Qt.MouseFocusReason
                    wrapMode:           TextArea.Wrap//换行
                    font.pixelSize:     20;
                    font.weight:        Font.Light
                    focus:              true;
                    textFormat:         TextArea.AutoText
                    selectByMouse:      true;
                    selectByKeyboard:   true
                    color:              "white"
                    placeholderText:    "接收区"
                }
            }
        }

        Item {
            id: item
            height: 1
            width: 1
        }

        /// 左侧发送框
        Rectangle {
            id:                 sendRect
            height:             rcvRect.height
            width:              rcvRect.width
            radius:             _margin /2
            color:              textColor
            ScrollView {
                anchors.fill: parent
                TextArea {
                    id:                 sendTextArea
                    cursorVisible:      true;
                    focusReason:        Qt.MouseFocusReason
                    wrapMode:           TextArea.Wrap//换行
                    font.pixelSize:     20;
                    font.weight:        Font.Light
                    focus:              true;
                    textFormat:         TextArea.AutoText
                    selectByMouse:      true;
                    selectByKeyboard:   true
                    color:              "white"
                    placeholderText:    "发送区"
                }
            }
        }
    }

    LinkSettings {
        anchors.left:       leftCol.right
        anchors.right:      parent.right
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        anchors.margins:    _margin*2
    }
}
