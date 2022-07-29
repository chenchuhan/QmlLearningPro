import QtQuick          2.12
import QtQuick.Window   2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts  1.3

import CC.Nettools 1.0
import CC.Controls 1.0

ApplicationWindow  {
    id:             root
    visible:        true
    width:          640
    height:         480
    title:          qsTr("多功能网络调试助手_v1.0")

    property int    index: 0
    //内部使用
    readonly property color textColor:      "#5B5B5B"//"#8E8E8E"     //4C  33  66 = 0.4*256
    readonly property color bgColor:        "#faead3"    //淡黄
    readonly property color themeColor:     "#a27e7e"    //淡酒红色
    readonly property color labelColor:     "black"
    readonly property real  margins:         5

    /// 已连接的颜色 "#019858"

    property real           ccPointSize:        13
    property color          labelColorS:            "white"

    TCPClient {
        id: globalTcpClient
        onRxDataChanged: {
            rcvTextArea.insert(rcvTextArea.length, rxData)
        }
    }

    function clearAllChecks() {
        for (var i=0; i<bottomItem.children.length; i++) {
           if (bottomItem.children[i].toString().startsWith("CCMenuButton"))
                bottomItem.children[i].checked = false
            }
    }

    Component.onCompleted: {
        clearAllChecks()
        bottomItem.children[0].checked = true
    }

    ///整体背景颜色 淡黄
    Rectangle {
        id:                 bgRect
        width:              parent.width
        height:             parent.height
        color:              bgColor
    }

    Rectangle {
        id:             toolBar
        anchors.top:    parent.top
        anchors.left:   parent.left
        width:          parent.width
        height:         bt1.height
        color:          "#FFE6D9"
        border.color:   "black"//themeColor
        border.width:   1
        RowLayout {
            id:                 bottomItem
            anchors.fill:       parent
            CCMenuButton {
                id:  bt1
                Layout.fillWidth: true
                text:  "TCP客户端"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 0
                }
            }
            CCMenuButton {
                id:  bt2
                Layout.fillWidth: true
                text:  "TCP服务器"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 1
                }
            }
            CCMenuButton {
                id:  bt3
                Layout.fillWidth: true
                text:  "UDP客户端"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 2
                }
            }
            CCMenuButton {
                id:  bt4
                Layout.fillWidth: true
                text:  "UDP服务器"
                onClicked: {
                    clearAllChecks()
                    checked = true
                    index = 3
                }
            }
        }

//        Rectangle {
//            width:      parent.width
//            height:     1
//            color:      themeColor
//        }
    }



    property bool   _isVisible:    false

    //内部使用
    property int    testData: 50
    property var    tcpClinet:              globalTcpClient
    property bool   isConnect:              tcpClinet.isConnected

    property string readme:  "1.自动连接;\n" +
                             "2.验证IP和端口;\n" +
                             "3.IP地址和端口等信息保存到本地;\n" +
                             "4.自动获取本地IP,并筛选正使用的IP\n"



    ///左侧文本框颜色
    Rectangle {
        id:                 rcvRect
        anchors.left:       parent.left
        anchors.right:      tcpConfig.left
        anchors.rightMargin:  margins
        anchors.top:        toolBar.bottom
        anchors.topMargin:  margins
        height:             (parent.height - toolBar.height) * 0.6
        radius:             margins /2
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
                placeholderText:    readme
            }
        }
    }

    /// 右侧配置TCP
    Item {
        id:                             tcpConfig
        anchors.right:                  parent.right
        anchors.rightMargin:            margins
        anchors.top:                    rcvRect.top
        width:                          tcpConfigColumn.width
        height:                         tcpConfigColumn.height
        Column {
            id:                         tcpConfigColumn
            anchors.centerIn:           parent
            spacing:                    2

            Component.onCompleted: {
                hostField.text = tcpClinet.tcpServerIP
                portField.text =  tcpClinet.tcpServerPort
                console.log("hostField.text:" , hostField.text,  "portField.text", portField.text)
            }

            Rectangle {
                color:   isConnect ? "#019858" : "#44000000"
                radius: margins
                width:  stateRow.width * 1.2
                height: stateRow.height * 1.2
                border.width:  isConnect ? 1 : 0
                border.color:  "white"
                Row {
                    id:     stateRow
                    anchors.centerIn:            parent
                    CCColoredImage {
                        source:                 isConnect ? "/images/CC/Monitor.svg" : "/images/CC/Disconnect.svg"
                        height:                 stateLabel.height
                        width:                  height
                    }
                    CCLabel {
                        id:                         stateLabel
                        text: isConnect ? "已连接"  : "未连接"
                        font.pointSize:             ccPointSize
                        color:                      isConnect ? "white" : labelColor
                    }
                }
            }

            Row {
                spacing:                    10
                CCLabel {
                    text:                   qsTr("服务器地址")
                    font.pointSize:         ccPointSize
                    color:                  labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                CCTextField {
                    id:                     hostField
                    onEditingFinished: {
                        if(text.length > 8 && text.length < 16) {
                            tcpClinet.tcpServerIP = text
                        }
                    }
                    onAccepted: {
                        if(text.length > 8 && text.length < 16) {
                            tcpClinet.tcpServerIP = text
                        }
                    }
                }
            }
            Row {
                spacing:        10
                CCLabel {
                    text:                   qsTr("服务器端口")
                    font.pointSize:         ccPointSize
                    color:                  labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                CCTextField {
                    id:         portField
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    anchors.verticalCenter: parent.verticalCenter
                    onEditingFinished: {
                        if(text.length > 0 && text.length < 6) {
                            tcpClinet.tcpServerPort = Number(text)
                        }
                    }
                    onAccepted: {
                        if(text.length > 0 && text.length < 6) {
                            tcpClinet.tcpServerPort = Number(text)
                        }
                    }
                }
            }

            Item {
                width: 1
                height: margins
            }

            Row {
                spacing:        10
                CCLabel {
                    text:                   qsTr("本地地址")
                    font.pointSize:         ccPointSize
                    color:                  labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                CCTextField {
                    id:                     locationIP
                    inputMethodHints:       Qt.ImhFormattedNumbersOnly
                    anchors.verticalCenter: parent.verticalCenter
                    enabled:                false
                    text:                   tcpClinet.deviceIP
                }
            }

            Row {
                spacing:        10
                CCLabel {
                    text:                   qsTr("本地端口")
                    font.pointSize:         ccPointSize
                    color:                  labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                CCTextField {
                    id:                     locationPort
                    inputMethodHints:       Qt.ImhFormattedNumbersOnly
                    anchors.verticalCenter: parent.verticalCenter
                    enabled:                false
                    text:                   "xxxxx"
//                    placeholderText:        "66666"
                }
            }

            Item {
                width: 1
                height: margins
            }

            RowLayout {
                CCLabel {
                    text:       "接收格式"
                    color:      "black"
                }
                CCRadioButton {
                    id:     rcvRb1
                    checked: true
                    textColor : labelColor//themeColor
                    text: qsTr("ASCII")
                    onCheckedChanged: {
                        if(checked)  tcpClinet.rcvState = text
                    }
                }
                CCRadioButton {
                    id:     rcvRb2
                    textColor : labelColor
                    text: qsTr("HEX")
                    onCheckedChanged: {
                        if(checked)  tcpClinet.rcvState = text
                    }
                }
            }

            RowLayout {
                id:                         rcvRow
                spacing:                    0
                CCButton1 {
                    Layout.fillWidth:  true
                    text:           qsTr("清除")
                    imageSource:    "/images/CC/Send.svg"
                    _themeC:                themeColor
                    onClicked: {
                        rcvTextArea.clear()
                    }
                }
                CCButton1 {
                    Layout.fillWidth:  true
                    text:                   isConnect ? qsTr("断开") : qsTr("连接")
                    imageSource:            isConnect ? "/images/CC/Disconnect.svg" : "/images/CC/Monitor.svg"
    //                anchors.verticalCenter: parent.verticalCenter
                    _themeC:                themeColor
                    onClicked: {
                        if(isConnect) {
                            //已经监听，发送断开指令
                            tcpClinet.disconnect()
                        }
                        else {
                            //没有连接，开始连接
                            tcpClinet.connect(hostField.text , Number(portField.text))
                        }
                    }
                }
            }
        }
    }
    /// 左侧发送框
    Rectangle {
        id:                 sendRect
        width:              rcvRect.width
        radius:             margins /2
        anchors.top:        rcvRect.bottom
        anchors.topMargin:  margins * 2
        anchors.bottom:     parent.bottom
        anchors.bottomMargin: margins
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

    /// 右侧按钮
    Column {
        anchors.left:                   tcpConfig.left
        anchors.top:                    sendRect.top

        RowLayout {
            CCLabel {
                text:       "发送格式"
                color:      "black"
            }
            CCRadioButton {
                id:     rb1
                checked: true
                textColor : labelColor//themeColor
                text: qsTr("ASCII")
            }
            CCRadioButton {
                id:     rb2
                textColor : labelColor
                text: qsTr("HEX")
            }
        }

        RowLayout {
            spacing:                    0
            CCButton1 {
                id:             display1
                Layout.fillWidth:  true
                text:           qsTr("发送")
                imageSource:    "/images/CC/Send.svg"
//                anchors.verticalCenter: parent.verticalCenter
                _themeC:                themeColor
                onClicked: {
                    tcpClinet.sendData(sendTextArea.text ,  0,  rb1.checked ?  "ASCII" : "HEX");
                }
            }
            CCButton1 {
                id:             display2
                Layout.fillWidth:  true

                text:           qsTr("清除")
                imageSource:    "/images/CC/Send.svg"
//                anchors.verticalCenter: parent.verticalCenter
                _themeC:                themeColor
                onClicked: {
                    sendTextArea.clear()
                }
            }
        }
    }
}




