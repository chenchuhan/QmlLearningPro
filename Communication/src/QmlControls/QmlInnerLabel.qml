import QtQuick                  2.12
import QtQuick.Controls         2.12

import QGroundControl.Palette       1.0
import QGroundControl.SGControls    1.0
import QGroundControl               1.0


Rectangle {
    id:                                 innerRect

    property alias _headertext:         headerText.text
    property real _pointSize:           10
    property alias _model:              rpt.model

    property var   _shortText
    property var   _longText

    height:                 clmnRoot.height + 16
    width:                  clmnRoot.width + 16
    color:                  "black"
    border.color:           qgcPal.sgTheme
    border.width:           1
    radius:                 4

    Column {
        id:                         clmnRoot
        anchors.centerIn:           parent
        spacing:                    2

        SGLabel {
            id:                     headerText
            font.pointSize:         _pointSize + 1
            anchors.horizontalCenter: parent.horizontalCenter
            color:                  "yellow"
        }

        Item {
            width:                  1
            height:                 2
        }

        Repeater {
            id:     rpt
            Row {
                spacing:            5
                ///简称
                SGLabel {
                    text:           _shortText[index] + ":"
                    color:          qgcPal.sgTheme
                    font.pointSize: _pointSize
                }
                ///详情
                SGLabel {
                    text:           _longText[index]
                    color:          'white'
                    font.pointSize: _pointSize
                }
            }
        }
    }
}



//Rectangle {
//    id:                     innerRect

//    property alias _text:           label.text
//    property alias _pointSize:      label.font.pointSize

//    implicitHeight:         label.height + 10
//    implicitWidth:          label.width + 10
//    color:                  qgcPal.sgBackground
//    border.color:           qgcPal.sgTheme
//    border.width:           1
//    radius:                 4

//    SGLabel {
//        id:                 label
//        anchors.centerIn:   parent
//        color:              qgcPal.sgTheme
//        font.pointSize:     10
//    }
//}





