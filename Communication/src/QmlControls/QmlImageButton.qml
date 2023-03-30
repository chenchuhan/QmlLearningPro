//import QtQuick 2.3
//import QtQuick.Controls 2.2//2.5
////import QtQuick.Controls.Styles 1.4
//import QtGraphicalEffects 1.0

//// TODO: Use QT styles. Use default button style + custom style entries
//import QGroundControl.ScreenTools 1.0
//import QGroundControl.Palette 1.0
import QGroundControl.Controls              1.0
//import QGroundControl   1.0

import QtQuick              2.3
import QtQuick.Controls     2.2
import QtGraphicalEffects   1.0

import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0

Button {
    id:     button
    radius: height/2

    property var imageExteaSource
    property bool imageExteaSourceEnabled:  false
    property real  imageScale:      1.5
    property real  borderWidth:     0
    property alias radius:          buttonBkRect.radius
    property alias bgColor:         buttonBkRect.color
    property real  _imageHeightScal:   0.8

    property color _themeC:                 qgcPal.sgTheme   //默认颜色，可外部传入
    //矩形背景颜色
    property color _backgroundColor
    //图标颜色
    property color _imageColor:             "white"
    //外圈颜色
    property color _borderColor:            "white"
    property color _textColor:              "white"         //文本颜色

    property bool colorVisible:             true

    text:               _toolStripAction.text
    imageSource:        _toolStripAction.iconSource

    property var        _toolStripAction:       undefined
    property alias      imageSource:            image.source


    property bool picked: false
    property bool oldPicked: false

    onPickedChanged: {
        if(picked) {
            _imageColor = "black";  _borderColor = "black";               _backgroundColor = qgcPal.ssHighlight
        }
        else {
            _imageColor = qgcPal.sgTheme;  _borderColor = qgcPal.sgTheme; _backgroundColor = "black"
        }
    }

//    //start_cch_20220409
//    onClicked: {
//         _toolStripAction.triggered()
//    }

    signal dropped(int idx)

    Component.onCompleted: {
        _imageColor = qgcPal.sgTheme;  _borderColor = qgcPal.sgTheme; _backgroundColor = "black"
    }

    QGCPalette { id: qgcPalDisabled;   colorGroupEnabled: false }
    // Initial state
    // Update state on status changed
    // Content Icon + Text
    contentItem: Item {
        //宽高由外部的决定
        id:                         contentLayoutItem
        QGCColoredImage {
            id:                         image
            anchors.centerIn:           parent
            height:                     parent.height * _imageHeightScal
            width:                      height
            color:                      _imageColor
            coVisible:                  button.colorVisible
//            source:                     imageExteaSourceEnabled ? imageExteaSource : imageSource
        }
    }

    background: Rectangle {
        id:                 buttonBkRect
        color:              _backgroundColor
        visible:            true           //!flat
        anchors.fill:       parent
        border.color:       _borderColor
        border.width:       2
        opacity:            0.8//0.7//0.5//0.8
    }

    // Change the colors based on button states
    /*
                默认    悬浮     按下
     背景     |  黑     小麦色    白
     图标     | 主题     黑      黑
     外圈     | 主题     黑      黑
    */

//    // Process hover events
//    MouseArea {
//        enabled:            !ScreenTools.isMobile
//        propagateComposedEvents: true
//        hoverEnabled:       true
//        preventStealing:    true
//        anchors.fill:       button
//        // Propagate events down
//        onClicked:          {
//            _toolStripAction.triggered(this)
//            mouse.accepted = false;
//        }
//        onDoubleClicked:    { mouse.accepted = false; }
//        onPositionChanged:  { mouse.accepted = false; }
//        onPressAndHold:     { mouse.accepted = false; }
//        onPressed:          { mouse.accepted = false  }
//        onReleased:         { mouse.accepted = false }

//        //按键想穿透必须 onClicked、onPressed、onReleased 加上  mouse.accepted = false
//    }
}




//import QtQuick 2.3
//import QtQuick.Controls 2.5
//import QtQuick.Controls.Styles 1.4
//import QtGraphicalEffects 1.0

//// TODO: Use QT styles. Use default button style + custom style entries
//import QGroundControl.ScreenTools 1.0
//import QGroundControl.Palette 1.0
//import QGroundControl.Controls              1.0
//import QGroundControl   1.0

//Button {
//    id:     button
////    width:  contentItem.contentWidth
////    height: contentItem.contentHeight
//    radius: height/2

//    property var imageSource:        ""
//    property var imageExteaSource
//    property bool imageExteaSourceEnabled:  false

//    property real  imageScale:      1.5
//    property real  borderWidth:     0

//    property alias radius:          buttonBkRect.radius
//    property alias bgColor:         buttonBkRect.color

//    property real  _imageHeightScal:   0.8
////    property alias imageHeight:     contentItem.height

//    //矩形背景颜色
//    property color _backgroundColor:        "#01ac7d"//qgcPal.ccButton     //#5DB6EA
//    //图标颜色
//    property color _imageColor:             "white"
//    //外圈颜色
//    property color _borderColor:            "white"

//    property bool colorVisible:      true

//    QGCPalette { id: qgcPalDisabled;   colorGroupEnabled: false }
//    // Initial state
//    state:                          "Default"
//    // Update state on status changed
//    // Content Icon + Text
//    contentItem: Item {
//        //宽高由外部的决定
//        id:                         contentLayoutItem

//        QGCColoredImage {
//            id:                         image
//            anchors.centerIn:           parent
//            height:                     parent.height * _imageHeightScal
//            width:                      height
//            color:                      _imageColor
//            coVisible:                  button.colorVisible
//            source:                     imageExteaSourceEnabled ? imageExteaSource : imageSource
//            visible:                    (imageSource !== "")
//        }
//    }

//    background: Rectangle {
//        id:                 buttonBkRect
//        color:              _backgroundColor
//        visible:            true           //!flat
//        anchors.fill:       parent
//        border.color:       _borderColor
//        border.width:       2
//        opacity:            0.8//0.7//0.5//0.8
//    }

//    // Change the colors based on button states
//    /*
//                默认    悬浮     按下
//     背景     |  黑     小麦色    白
//     图标     | 主题     黑      黑
//     外圈     | 主题     黑      黑
//    */
//    states: [
//        State {
//            name: "Hovering"
//            PropertyChanges {
//                target: button;
//                _backgroundColor:          (checked || pressed) ? 'white' :     "#F5DEB3"
//                _imageColor:               (checked || pressed) ? 'black' :     "black"
//                _borderColor:              (checked || pressed) ? 'black' :     "black"
//            }
//            PropertyChanges {
//                target: buttonBkRect
//                visible: true
//            }
//        },

//        State {
//            name: "Default"
//            PropertyChanges {
//                target: button;
//                _backgroundColor:     "black"
//                _imageColor:           qgcPal.sgTheme
//                _borderColor:          qgcPal.sgTheme
//            }

//            PropertyChanges {
//                target: buttonBkRect
//                visible: !flat || (checked || pressed)
//            }
//        }
//    ]

//    transitions: [
//        Transition {
//            from: ""; to: "Hovering"
//            ColorAnimation { duration: 200 }//200
//        },
//        Transition {
//            from: "*"; to: "Pressed"
//            ColorAnimation { duration: 10 }
//        }
//    ]

//    // Process hover events
//    MouseArea {
//        enabled:            !ScreenTools.isMobile
//        propagateComposedEvents: true
//        hoverEnabled:       true
//        preventStealing:    true
//        anchors.fill:       button
//        onEntered:          button.state = 'Hovering'
//        onExited:           button.state = 'Default'
//        // Propagate events down
//        onClicked:          { mouse.accepted = false; }
//        onDoubleClicked:    { mouse.accepted = false; }
//        onPositionChanged:  { mouse.accepted = false; }
//        onPressAndHold:     { mouse.accepted = false; }
//        onPressed:          { mouse.accepted = false  }
//        onReleased:         { mouse.accepted = false }
//    }
//}


