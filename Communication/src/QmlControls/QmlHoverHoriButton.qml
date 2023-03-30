import QtQuick 2.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

// TODO: Use QT styles. Use default button style + custom style entries
import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0
import QGroundControl.Controls              1.0
import QGroundControl   1.0

// TODO: use QT palette
Button {
    id:     button
    width:  contentLayoutItem.contentWidth //(contentLayoutItem.anchors.margins * 2)  //margins :1.5
    height: contentLayoutItem.contentHeight //(contentLayoutItem.anchors.margins * 2)
    //height: 60//contentLayoutItem.contentHeight +  (contentLayoutItem.anchors.margins * 8)
//    flat:  true

    property color borderColor:     qgcPal.windowShadeDark

    property alias fontPointSize:   innerText.font.pointSize

    property var imageSource:        ""
    property var imageExteaSource
    property bool imageExteaSourceEnabled:  false
//    property alias imageSource:     innerImage.source
    property alias contentWidth:    innerText.contentWidth
    property alias textColor:       innerText.color;
    property alias textBold:        innerText.font.bold;

    property real  imageScale:      1.5
    property real  borderWidth:     0
    property real  contentMargins:  innerText.height * 0.1

    property alias radius:          buttonBkRect.radius
    property alias bgColor:         buttonBkRect.color

    property real maxHeight

    //其它点击的时候，这个需要清零
//    activeFocusOnPress: true
//    onCheckedChanged: checkable = false
    /*
             失能  使能   悬浮   按下
     背景 |   主题  主题  小麦色   红
     文本 |   白    黑   黑      淡青色
     图标 |   白    黄   黑      淡青色
    */

    //矩形背景颜色
//    property color _defaultBackgroundColor: "#01ac7d"
    property color _backgroundColor:        "#01ac7d"//qgcPal.ccButton     //#5DB6EA

    //文本颜色
//    property color _disabledTextColor:      "white"
    property color _textColor:              "white"

    //图标颜色
//    property color _defaultImageColor:      "white"
    property color _imageColor:              "white"

//    //start_cch_xx_20200525
    property bool colorVisible:      true

    QGCPalette { id: qgcPalDisabled; colorGroupEnabled: false }
//    // Initial state
    state:                          "Default"
    // Update state on status changed
    // Content Icon + Text
    contentItem: Row {
        id:                         contentLayoutItem
        anchors.centerIn:           parent
        spacing:                    contentMargins
//            anchors.verticalCenter:     parent.verticalCenter
//            spacing:                    contentMargins
//            width:                      parent.height

        QGCColoredImage {
            id:                     innerImage
            height:                 innerText.implicitHeight * 1.1
            width:                  height
            sourceSize.height:      height
            sourceSize.width:       width
            color:                  _imageColor
            anchors.verticalCenter: parent.verticalCenter
            coVisible:              button.colorVisible
            source:                 imageExteaSourceEnabled ? imageExteaSource : imageSource
            visible:                (imageSource !== "")
        }
        SGLabel {
            //contentHeight implicitHeight height: 15  width
            //contentWidth implicitWidth width  : 30
            id:                      innerText
            text:                    button.text
            color:                  _textColor
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize:         QGroundControl.corePlugin.sgPointSize //11//12//9   //150% 下 10已经OK
        }
    }

    background: Rectangle {
        id:                 buttonBkRect
//        implicitWidth:      parent.width//ScreenTools.implicitButtonWidth
//        implicitHeight:     parent.height//ScreenTools.implicitButtonHeight
//        width:              parent.width
//        height:             parent.height

//        implicitWidth:      contentLayoutItem.contentWidth + 10
//        implicitHeight:     contentLayoutItem.contentHeight + 2/*+ 6*/
        radius:             6//3
        color:              _backgroundColor
        visible:            true//!flat

        anchors.fill:       parent
    }

    // Change the colors based on button states
    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: button;
//                _backgroundColor:          (checked || pressed) ? qgcPal.buttonHighlight : qgcPal.hoverColor
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
//            PropertyChanges {
//                target: button;
//                _backgroundColor:   enabled ? ((checked || pressed) ? qgcPal.buttonHighlight :     _defaultBackgroundColor) :  _defaultBackgroundColor
//                _textColor:         enabled ? ((checked || pressed) ? qgcPal.buttonHighlightText : "black") :     _disabledTextColor
//                _imageColor:        enabled ? ((checked || pressed) ? 'purple' :     "black") :  _defaultImageColor
//            }

            PropertyChanges {
                target: button;
                _backgroundColor:   enabled ?   "#01ac7d"   :      "#01ac7d"
                _textColor:         enabled ?   "black" :          "white"
                _imageColor:        enabled ?   "yellow":           "white"
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
        enabled:            !ScreenTools.isMobile
        propagateComposedEvents: true
        hoverEnabled:       true
        preventStealing:    true
        anchors.fill:       button
        onEntered:          button.state = 'Hovering'
        onExited:           button.state = 'Default'
        // Propagate events down
        onClicked:          {
            mouse.accepted = false;
        }
        onDoubleClicked:    { mouse.accepted = false; }
        onPositionChanged:  { mouse.accepted = false; }
        onPressAndHold:     { mouse.accepted = false; }
        onPressed:          {
            mouse.accepted = false
        }
        onReleased:         { mouse.accepted = false }
    }
}






//import QtQuick 2.3
////import QtQuick.Controls 2.2
//import QtQuick.Controls 2.5

////import QtQuick.Controls 1.2

//import QtQuick.Controls.Styles 1.4
//import QtGraphicalEffects 1.0

//// TODO: Use QT styles. Use default button style + custom style entries
//import QGroundControl.ScreenTools 1.0
//import QGroundControl.Palette 1.0
//import QGroundControl.Controls              1.0

//// TODO: use QT palette
//Button {
//    id:     button
////    width:  contentLayoutItem.contentWidth + (contentLayoutItem.anchors.margins * 2)
//    //height: 60//contentLayoutItem.contentHeight +  (contentLayoutItem.anchors.margins * 8)
////    flat:  true

//    property color borderColor:     qgcPal.windowShadeDark

//    property alias fontPointSize:   innerText.font.pointSize

//    property var imageSource
//    property var imageExteaSource
//    property bool imageExteaSourceEnabled:  false
////    property alias imageSource:     innerImage.source
//    property alias contentWidth:    innerText.contentWidth
//    property alias textColor:       innerText.color;
//    property alias textBold:        innerText.font.bold;

//    property real  imageScale:      1.5
//    property real  borderWidth:     0
//    property real  contentMargins:  innerText.height * 0.1

//    property alias radius:          buttonBkRect.radius
//    property alias bgColor:         buttonBkRect.color

//    /*
//             失能  使能   悬浮   按下
//     背景 |   主题  主题  小麦色   红
//     文本 |   白    黑   黑      淡青色
//     图标 |   白    黄   黑      淡青色
//    */

//    //矩形背景颜色
//    property color _defaultBackgroundColor: "#01ac7d"
//    property color _backgroundColor:       _defaultBackgroundColor//qgcPal.ccButton     //#5DB6EA

//    //文本颜色
//    property color _disabledTextColor:      "white"
//    property color _textColor:              _disabledTextColor

//    //图标颜色
//    property color _defaultImageColor:      "white"
//    property color _imageColor:              _defaultImageColor

////    //start_cch_xx_20200525
//    property bool colorVisible:      true

//    QGCPalette { id: qgcPalDisabled; colorGroupEnabled: false }
////    // Initial state
//    state:                          "Default"
//    // Update state on status changed
//    // Content Icon + Text
//    contentItem: Item {
//        id:                             contentLayoutItem
////        anchors.fill:                   parent
////        anchors.margins:                contentMargins
//        anchors.centerIn:               parent
//        width:                          row.implicitWidth
//        height:                         row.implicitHeight

//        Row {
//            id:                         row
//            anchors.verticalCenter:     parent.verticalCenter
//            spacing:                    contentMargins
//            width:                      parent.height

//            QGCColoredImage {
//                id:                     innerImage
//                height:                 innerText.height * imageScale
//                width:                  height
//                color:                  _imageColor
//                sourceSize.height:      height
//                sourceSize.width:       width
//                anchors.verticalCenter: parent.verticalCenter
//                coVisible:              button.colorVisible
//                source:                 imageExteaSourceEnabled ? imageExteaSource : imageSource
//            }
//            SGLabel {
//                id:                         innerText
//                text:                       button.text
//                color:                      _textColor
//                anchors.verticalCenter:     parent.verticalCenter
//                font.pointSize:             11//11//12//9
//            }
//        }
//    }

//    background: Rectangle {
//        id:                 buttonBkRect
////        implicitWidth:      parent.width//ScreenTools.implicitButtonWidth
////        implicitHeight:     parent.height//ScreenTools.implicitButtonHeight
////        width:              parent.width
////        height:             parent.height

////        implicitWidth:      contentLayoutItem.contentWidth + 10
//        implicitHeight:     contentLayoutItem.contentHeight + 2/*+ 6*/
//        radius:             3
//        color:              _backgroundColor
//        visible:            true//!flat
//        border.width:       borderWidth
//        border.color:       borderColor
//    }

//    // Change the colors based on button states
//    states: [
//        State {
//            name: "Hovering"
//            PropertyChanges {
//                target: button;
////                _backgroundColor:          (checked || pressed) ? qgcPal.buttonHighlight : qgcPal.hoverColor
//                _backgroundColor:          (checked || pressed) ? 'red' :       "#F5DEB3"
//                _textColor:                (checked || pressed) ? '#E1FFFF' :    'black'
//                _imageColor:               (checked || pressed) ? '#E1FFFF' :    "black"
//            }
//            PropertyChanges {
//                target: buttonBkRect
//                visible: true
//            }
//        },

//        State {
//            name: "Default"
////            PropertyChanges {
////                target: button;
////                _backgroundColor:   enabled ? ((checked || pressed) ? qgcPal.buttonHighlight :     _defaultBackgroundColor) :  _defaultBackgroundColor
////                _textColor:         enabled ? ((checked || pressed) ? qgcPal.buttonHighlightText : "black") :     _disabledTextColor
////                _imageColor:        enabled ? ((checked || pressed) ? 'purple' :     "black") :  _defaultImageColor
////            }

//            PropertyChanges {
//                target: button;
//                _backgroundColor:   enabled ?   "#01ac7d"   :      "#01ac7d"
//                _textColor:         enabled ?   "black" :          "white"
//                _imageColor:        enabled ?   "yellow":           "white"
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
//        onPressed:          { mouse.accepted = false }
//        onReleased:         { mouse.accepted = false }
//    }
//}
