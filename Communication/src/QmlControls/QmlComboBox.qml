/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.11
import QtQuick.Window           2.3
import QtQuick.Controls         2.4
import QtQuick.Controls.impl    2.4
import QtQuick.Templates        2.4 as T

import Palette 1.0
import QmlControls 1.0

///--1.显示的宽一般由外部决定
T.ComboBox {
    id:             control
    //start_cch_20210722
    padding:        10//ScreenTools.isMobile ?  ScreenTools.comboBoxPadding*0.2 : ScreenTools.comboBoxPadding
    spacing:        10//ScreenTools.isMobile ?  ScreenTools.comboBoxPadding*0.4 : ScreenTools.defaultFontPixelWidth

    font.pixelSize:     ScreenTools.minPixelSize

    //一般由外部决定 这样能统一宽和高

    implicitWidth:       contentItem.implicitWidth
    implicitHeight:      contentItem.implicitHeight * 2

                        //Math.max(background ? background.implicitHeight : 0,
                      //       Math.max(contentItem.implicitHeight, indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    leftPadding:    padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding:   padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width)

    property bool   centeredLabel:  false

    ////false  决定了按照控件显示的宽还是按照列表的宽来做
    property bool   sizeToContents: false
    property string alternateText:  ""

    property var    _qgcPal:            Palette {}
    property real   _largestTextWidth:  0
    property real   _popupWidth:        sizeToContents ? _largestTextWidth + itemDelegateMetrics.leftPadding + itemDelegateMetrics.rightPadding : control.width
    property bool   _onCompleted:       false

    TextMetrics {
        id:                  textMetrics
        font.pixelSize:      ScreenTools.minText
        font.bold:          true
    }

    ItemDelegate {
        id:             itemDelegateMetrics
        visible:        false
        font.family:    control.font.family
        font.pixelSize:     control.font.pixelSize
    }

    function _adjustSizeToContents() {
        if (_onCompleted && sizeToContents) {
            _largestTextWidth = 0
            for (var i = 0; i < model.length; i++){
                textMetrics.text = model[i]
                _largestTextWidth = Math.max(textMetrics.width, _largestTextWidth)
            }
        }
    }

//    onModelChanged: _adjustSizeToContents()
    Component.onCompleted: {
        _onCompleted = true
        _adjustSizeToContents()
    }

    // The items in the popup
    // 展开后各个文本项
    delegate: ItemDelegate {
        width:  _popupWidth
        height: Math.round(popupItemMetrics.height * 1.75)

        property string _text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        TextMetrics {
            id:             popupItemMetrics
            font:           control.font
            text:           _text
        }
        contentItem: QmlLabel {
            text:                   _text
            font:                   control.font
            color:                  control.currentIndex === index ? 'black' : 'black'
            verticalAlignment:      Text.AlignVCenter
            elide:                  Text.ElideRight
            _min:                   true
        }
        background: Rectangle {
            color:                  control.currentIndex === index ? _qgcPal.sgTheme : _qgcPal.ssHighlight
        }

        highlighted:                control.highlightedIndex === index
    }

    indicator: QmlColoredImage {
        anchors.rightMargin:    control.padding
        anchors.right:          parent.right
        anchors.verticalCenter: parent.verticalCenter
        height:                 ScreenTools.defaultWidth
        width:                  height
        source:                 "/qmlimages/arrow-down.png"
        color:                  'black'//_qgcPal.text
    }

    // The label of the button
    contentItem: Item {
        implicitWidth:                  text.implicitWidth
        implicitHeight:                 text.implicitHeight

        QmlLabel {
            id:                         text
            anchors.verticalCenter:     parent.verticalCenter
            text:                       control.alternateText === "" ? control.currentText : control.alternateText
            font:                       control.font
            color:                      'black'
            _min:                         true
        }
    }
    ///不展开的情况下显示框
    background: Rectangle {
        anchors.fill:   parent
        color:          "#F5DEB3"   //_qgcPal.ssHighlight
        border.color:   "white"     //_qgcPal.text
        border.width:   1
    }
    ///展开项综合
    popup: T.Popup {
        y:              control.height
        width:          _popupWidth
        height:         Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        topMargin:      6
        bottomMargin:   6

        contentItem: ListView {
            clip:                   true
            implicitHeight:         contentHeight
            model:                  control.delegateModel
            currentIndex:           control.highlightedIndex
            highlightMoveDuration:  0


            Rectangle {
                z:              10
                width:          parent.width
                height:         parent.height
                color:          "transparent"
                border.color:   _qgcPal.text
            }

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color:      control.palette.window
        }
    }
}
