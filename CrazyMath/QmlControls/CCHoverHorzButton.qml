

import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import QmlControls  1.0

Button {
    id:     button
    width:  contentLayoutItem.contentWidth
    height: contentLayoutItem.contentHeight

    //图片
    property var imageSource:        ""
    property var imageExteaSource
    property bool imageExteaSourceEnabled:  false

    //文本
    property alias fontPointSize:   innerText.font.pointSize
    property alias contentWidth:    innerText.contentWidth

    //背景
    property alias radius:          buttonBkRect.radius
    property alias bgColor:         buttonBkRect.color

    property real  contentMargins:  innerText.height * 0.2

    contentItem: Row {
        id:                         contentLayoutItem
        anchors.centerIn:           parent
        spacing:                    contentMargins

        CCColoredImage {
            id:                     innerImage
            height:                 innerText.implicitHeight * 1.1
            width:                  height
            sourceSize.height:      height
            sourceSize.width:       width
            color:                  _imageColor
            anchors.verticalCenter: parent.verticalCenter
            source:                 imageExteaSourceEnabled ? imageExteaSource : imageSource
            visible:                (imageSource !== "")
        }
        CCLabel {
            id:                      innerText
            text:                    button.text
            color:                  _textColor
            font.pointSize:         15
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    background: Rectangle {
        id:                 buttonBkRect
        radius:             height/4
        color:              _backgroundColor
        visible:            true
        anchors.fill:       parent
    }

    // Change the colors based on button states
    /*
             失能   使能   悬浮   按下
     背景 |   主题   主题  小麦色   红
     文本 |   白     黑   黑      淡青色
     图标 |   白     黄   黑      淡青色
    */
    property color _backgroundColor:        _themeColor     //矩形背景颜色
    property color _textColor:              "white"         //文本颜色
    property color _imageColor:             "white"        //图标颜色

    readonly property color _themeColor:        mainRoot.bgColor//"#84C1FF"
    readonly property color _highThemeColor:    mainRoot.subColor//"#84C1FF"


    state:                          "Default"

    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: button;
                _backgroundColor:          (checked || pressed) ? 'red' :       "#F5DEB3"
                _textColor:                (checked || pressed) ? '#E1FFFF' :    'black'
                _imageColor:               (checked || pressed) ? '#E1FFFF' :    "black"
            }
            PropertyChanges {
                target: buttonBkRect
                visible: true
            }
        },

        State {
            name: "Default"
            PropertyChanges {
                target: button;
                _backgroundColor:       enabled ?   _themeColor   :      _themeColor
                _textColor:             enabled ?   "white" :           "white"
                _imageColor:            enabled ?   _highThemeColor:     _highThemeColor
            }
            PropertyChanges {
                target: buttonBkRect
                visible: !flat || (checked || pressed)
            }
        }
    ]

    transitions: [
        Transition {
            from: ""; to: "Hovering"
            ColorAnimation { duration: 200 }//200
        },
        Transition {
            from: "*"; to: "Pressed"
            ColorAnimation { duration: 10 }
        }
    ]

    // Process hover events
    MouseArea {
        propagateComposedEvents: true
        hoverEnabled:       true
        preventStealing:    true
        anchors.fill:       button
        onEntered:          button.state = 'Hovering'
        onExited:           button.state = 'Default'
        // Propagate events down
        onClicked:          { mouse.accepted = false;}
        onDoubleClicked:    { mouse.accepted = false; }
        onPositionChanged:  { mouse.accepted = false; }
        onPressAndHold:     { mouse.accepted = false; }
        onPressed:          { mouse.accepted = false }
        onReleased:         {
            mouse.accepted = false
            button.state = 'Default'
        }
    }
}
