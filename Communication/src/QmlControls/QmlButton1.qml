
import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import QmlControls 1.0

Button {
    id:         button
    padding:    5
    property bool   _isAndroidS:               false
    //图片
    property var    imageSource:            "/qmlimages/arrow-down.png"
    property color  _themeC:                "#00AEAE"           //默认颜色，可外部传入
    property color _backgroundColor:        "white"             //_backgroundC                    //矩形背景颜色
    property color _imageColor :            "yellow"
    property color _borderColor

    contentItem: Row {
        id:                             content
        anchors.centerIn:               parent
        spacing:                        5
        //宽高外部已经传入
        QmlColoredImage {
            id:                         image
            width:                      innerText.implicitHeight * 1.1
            height:                     width
            sourceSize.height:          height
            sourceSize.width:           width
            source:                     imageSource
            color:                      _imageColor
        }
        QmlLabel {
            id:                         innerText
            text:                        button.text
            color:                      _imageColor
            font.pointSize:             12
            anchors.verticalCenter:     parent.verticalCenter
        }
    }

    background: Rectangle   {
        id:                 buttonBkRect
        radius:             _isAndroidS ? 12: 6
        color:              _backgroundColor
        anchors.fill:       parent
        border.color:       _borderColor
        border.width:       2
    }

    // Change the colors based on button states
    /*
                   默认         |     悬浮
             |  默认  |  按下   |  默认 | 按下
     背景     |  黑      小麦色  |  白
     图标     | 主题      黑     |  黑
     外圈     | 主题      黑     |  黑
    */
    state:                                  "Default"
    states: [
        State {
            name:         "Default"
            PropertyChanges {           //qgcPal.ssHighlight
                target: button;
                _borderColor:                  pressed ?   "black" : "white"
                _backgroundColor:             (pressed ?   "#FFFFCE": _themeC)
                _imageColor:                  (pressed ?   "black" :  "white")
            }
        },
        State {
            name: "Hovering"
            PropertyChanges {
                target: button;
                _backgroundColor:          (checked || pressed) ? 'green' :      "#F5DEB3"
                _imageColor:               (checked || pressed) ? '#E1FFFF' :    "black"
            }
            PropertyChanges {
                target: buttonBkRect
                visible: true
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

    MouseArea {
        propagateComposedEvents: true
        hoverEnabled:       true
        preventStealing:    true
        anchors.fill:       button
        onEntered:          button.state = 'Hovering'
        onExited:           button.state = 'Default'
        // Propagate events down
        onClicked:          { mouse.accepted = false; }
        onDoubleClicked:    { mouse.accepted = false; }
        onPositionChanged:  { mouse.accepted = false; }
        onPressAndHold:     { mouse.accepted = false; }
        onPressed:          { mouse.accepted = false }
        onReleased:         { mouse.accepted = false }
    }
}
