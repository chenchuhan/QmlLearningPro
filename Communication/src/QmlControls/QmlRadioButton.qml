import QtQuick                  2.11
import QtQuick.Controls         2.4
import QtQuick.Controls.Styles  1.4


RadioButton {
    id:             control
    font.pointSize: 12

    property color  textColor:  "red"
    property color  subColor:   "#019858"
    property bool   _noText:    text === ""

    indicator: Rectangle {
        implicitWidth:          20
        implicitHeight:         width
        color:                  "white"
        border.color:           "black"
        radius:                 height / 2
        opacity:                control.enabled ? 1 : 0.5
        x:                      control.leftPadding
        y:                      parent.height / 2 - height / 2
        Rectangle {
            anchors.centerIn:   parent
            // Width should be an odd number to be centralized by the parent properly
            width:              2 * Math.floor(parent.width / 4) + 1
            height:             width
            antialiasing:       true
            radius:             height * 0.5
            color:              subColor
            visible:            control.checked
        }
    }

    contentItem: CCLabel {
        text:               control.text
        font.family:        control.font.pointSize
        font.pointSize:     control.font.pointSize
        font.bold:          true
        color:              control.textColor
        opacity:            enabled ? 1.0 : 0.3
        verticalAlignment:  Text.AlignVCenter
        leftPadding:        control.indicator.width + (_noText ? 0 : 4)
    }
}
