/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Controls 2.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0

Rectangle {
    id:         _root
    color:      qgcPal.sgToolbarBackground//    width:      _idealWidth < repeater.contentWidth ? repeater.contentWidth : _idealWidth
//    height:     Math.min(maxHeight, toolStripColumn.height + (flickable.anchors.margins * 2))
    height:     col.height      //toolStripColumn.height
    width:      col.width * 1.15

    radius:     ScreenTools.defaultFontPixelWidth / 2

    property real buttonHeight: col.children[0].children[0].height
    property real _spacing:   (maxHeight > (buttonHeight*6+2)) ? (maxHeight-buttonHeight*6-2)/6 :  0 //ScreenTools.defaultFontPixelWidth

    property alias colSpacing: col.spacing

    property alias  model:              repeater.model
    property real   maxHeight           ///< Maximum height for control, determines whether text is hidden to make control shorter
//    property alias  title:              titleLabel.text

    //模拟点击
    function simulateClick(buttonIndex) {
        buttonIndex = buttonIndex + 1 // skip over title
        col.children[buttonIndex].clicked()
    }

    // Ensure we don't get narrower than content
    property real _idealWidth: (ScreenTools.isMobile ? ScreenTools.minTouchPixels : ScreenTools.defaultFontPixelWidth * 8) + col.anchors.margins * 2

    signal dropped(int index)
    signal preFlightChecklist

    DeadMouseArea {
        anchors.fill: parent
    }

    QGCFlickable {
        id:                 flickable
//        anchors.margins:    ScreenTools.defaultFontPixelWidth * 0.4
        anchors.top:        parent.top
        anchors.horizontalCenter: parent.horizontalCenter
//        width:              parent.width
        width:              col.width
        height:             col.height
        contentHeight:      col.height
        flickableDirection: Flickable.VerticalFlick
        clip:               true

        Column {
           id:     col
           spacing:                     _spacing //ScreenTools.defaultFontPixelWidth
           anchors.horizontalCenter:     parent.horizontalCenter
//           width:                        parent.width
           width:                       col.children[0].width


           Repeater {
                id: repeater

                Column {
                    anchors.horizontalCenter:       parent.horizontalCenter
//                    width:                         parent.width

                    width:                        buttonTemplate.width

                    spacing:                     _spacing

                    SGHoverHoriButton {
                        id:                             buttonTemplate
                        anchors.horizontalCenter:       parent.horizontalCenter


    //                    width:                      parent.width*0.9
    //                    height:                     30

                        radius:                     6
                        autoExclusive:              true

                        enabled:        modelData.enabled
                        visible:        modelData.visible
                        imageSource:    modelData.showAlternateIcon ? modelData.alternateIconSource : modelData.iconSource
                        text:           modelData.text
    //                    checked:        modelData.checked
    //                    checkable:      modelData.dropPanelComponent || modelData.checkable
    //                    onCheckedChanged: modelData.checked = checked

                        onClicked: {
                            modelData.triggered(this)
                        }
                    }

                    Rectangle {
                        anchors.horizontalCenter:   parent.horizontalCenter
                        width:                      buttonTemplate.width
                        height:                     index===0 ? 2 : 0
                        color:                      qgcPal.sgTheme
                        visible:                    (index===0)
                    }
                }
            }
        }
    }
}
