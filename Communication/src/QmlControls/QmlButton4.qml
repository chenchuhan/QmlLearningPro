
import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0
import QGroundControl.Controls              1.0
import QGroundControl   1.0


Button {
    id:     button
    width:  contentLayoutItem.contentWidth
    height: contentLayoutItem.contentHeight

    text:           _buttonAction.text
//    checkable:       _buttonAction.checkable
    property bool picked: false

    //每一个都有这个信号
    Connections{
        target:                     rect
        onListIndex:                {
            picked = (idx===index)
        }
    }

    onClicked: {
        listIndex(index)
         modelData.triggered(this,picked)      //最好放 Connections 里
    }

    Component.onCompleted: {
        if(_idx ===   index)    picked = true
        else                    picked = false
    }

    //传入
    property bool   _isAndroidS:              false
    property var    _buttonAction:    undefined
    //图片
    property var imageSource:       _buttonAction.iconSource

    //文本
    property alias fontPointSize:   innerText.font.pointSize
    property alias contentWidth:    innerText.contentWidth

    //背景
    property alias radius:          buttonBkRect.radius
    property alias bgColor:         buttonBkRect.color

    property real  contentMargins:  innerText.height * (_isAndroidS ? 0.05 : 0.2)

    contentItem: Row {
        id:                         contentLayoutItem
        anchors.centerIn:           parent
        spacing:                    contentMargins

        QGCColoredImage {
            id:                     innerImage
            height:                 innerText.implicitHeight * 1.1
            width:                  height
            sourceSize.height:      height
            sourceSize.width:       width
            color:                  _imageColor
            anchors.verticalCenter: parent.verticalCenter
            source:                 imageSource// imageExteaSourceEnabled ? imageExteaSource : imageSource
            visible:                (imageSource !== "")
        }
        SGLabel {
            id:                      innerText
            text:                    button.text
            color:                  _textColor
            font.pointSize:         _isAndroidS ? 12 :14
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    background: Rectangle {
        id:                 buttonBkRect
        radius:             _isAndroidS ? height*0.2 : 2
        color:              _backgroundColor
        visible:            true
        anchors.fill:       parent
    }

    // Change the colors based on button states

    property color _backgroundColor:        _backgroundC                    //矩形背景颜色
    property color _textColor:              "white"         //文本颜色
    property color _imageColor:             "white"         //图标颜色

    property color _backgroundC:             "#272727"       //默认颜色
    property color _themeC:                 qgcPal.sgTheme   //默认颜色，可外部传入

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
            name: "Hovering"
            PropertyChanges {
                target: button;
                _backgroundColor:          /*(checked || pressed)*/picked ? qgcPal.ssHighlight :     _themeC
                _textColor:                /*(checked || pressed)*/picked ? 'black' :                'black'
                _imageColor:               /*(checked || pressed)*/picked ? 'black' :                "yellow"
            }
        },
        State {
            name: "Default"
            PropertyChanges {
                target: button;
                _backgroundColor:              /*(checked || pressed)*/picked ? qgcPal.ssHighlight :   Qt.rgba(0,0,0,0)
                _textColor:                    /*(checked || pressed)*/picked ? "black" :              _themeC
                _imageColor:                   /*(checked || pressed)*/picked ? "black" :              "white"
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
    /*propagateComposedEvents 为 true，可以传递鼠标事件
      mouse.accepted = false 即可通过该MouseArea传递到其上层
        (注意是它覆盖的别的层，其它层覆盖这里，当然没问题的)

    */
    MouseArea {
        propagateComposedEvents: true
        hoverEnabled:       true
        preventStealing:    true
        anchors.fill:       button
//        onEntered:          button.state = 'Hovering'
//        onExited:           button.state = 'Default'
        // Propagate events down
//        onClicked:  {
//            mouse.accepted = false;
//        }
//        onDoubleClicked:    { mouse.accepted = true; }
//        onPositionChanged:  { mouse.accepted = true; }
//        onPressAndHold:     { mouse.accepted = true; }
        onPressed:          {
            mouse.accepted = false   //加入穿透，checked 将变为 false
        }
        onReleased:  {
            button.state = 'Default'
        }
    }
}
