
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

    //传入
    property bool _isAndroidS:              false
    //图片
    property var imageSource:               ""
    property var imageExteaSource
    property bool imageExteaSourceEnabled:  false

    //文本
    property alias fontPointSize:   innerText.font.pointSize
    property alias contentWidth:    innerText.contentWidth

    //背景
    property alias radius:          buttonBkRect.radius
    property alias bgColor:         buttonBkRect.color

    property real  contentMargins:  innerText.height * 0.2

    property bool _isChecked:       false

    on_IsCheckedChanged: {
        if(_isChecked) {
            _imageColor = "black";        _textColor = "black";
            buttonBkRect.visible = true;  _backgroundColor = qgcPal.ssHighlight;
        }
        else {
            _imageColor = "white";      _textColor = qgcPal.sgTheme;
            buttonBkRect.visible = false
        }
    }

    Component.onCompleted: {
        _imageColor = "white";      _textColor = qgcPal.sgTheme;
        buttonBkRect.visible = false
    }

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
            source:                 imageExteaSourceEnabled ? imageExteaSource : imageSource
            visible:                (imageSource !== "")
        }
        CCLabel {
            id:                      innerText
            text:                    button.text
            color:                  _textColor
            font.pointSize:         _isAndroidS ? 12 :14
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

    property color _backgroundColor:        _backgroundC                    //矩形背景颜色
    property color _textColor:              "white"         //文本颜色
    property color _imageColor:             "white"        //图标颜色

    property color _backgroundC:            "black"         // "#272727"       //默认颜色
    property color _themeC:                 qgcPal.sgTheme   //默认颜色，可外部传入

    /*
             默认    悬浮    按下
     背景 |   黑     主题    小麦色
     文本 |   主题    黑      黑
     图标 |   白     黄      黑
    */


    // Process hover events
    MouseArea {
        propagateComposedEvents: true
        hoverEnabled:       true
        preventStealing:    true
        anchors.fill:       button
        // Propagate events down
        onClicked:          { mouse.accepted = false;}
        onDoubleClicked:    { mouse.accepted = false; }
        onPositionChanged:  { mouse.accepted = false; }
        onPressAndHold:     { mouse.accepted = false; }
        onPressed:          { mouse.accepted = false; }
        onReleased:         { mouse.accepted = false; }
    }
}
