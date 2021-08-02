import QtQuick.Window 2.12
import QtQuick                  2.12
import QtQuick.Controls         1.2

Window {
    visible:    true
    width:      192 * 4
    height:     108 * 4
    color:      "grey"

    property real _offset: leftStick.width/2

    JoystickThumbPad {
        id:                     leftStick
        anchors.leftMargin:     xPositionDelta  + _offset
        anchors.bottomMargin:   -yPositionDelta + _offset
        anchors.left:           parent.left
        anchors.bottom:         parent.bottom
        width:                  100
        height:                 100
        imageHeight:            20
    }

    JoystickThumbPad {
        id:                     rightStick
        anchors.rightMargin:    -xPositionDelta + _offset
        anchors.bottomMargin:   -yPositionDelta + _offset
        anchors.right:          parent.right
        anchors.bottom:         parent.bottom
        width:                  100
        height:                 100
        imageHeight:            20
    }

    Output {
        id:                     output
        x:                      50
        y:                      10
        height:                 parent.height - leftStick.height*2 - y*2
        width:                  parent.width - x*2
    }

    ///--You can also use signals
    Timer {
        interval:   50          // 20Hz
        running:    true
        repeat:     true
        onTriggered: {
            output.leftX  = leftStick.xAxis
            output.leftY  = leftStick.yAxis
            output.rightX = rightStick.xAxis
            output.rightY = rightStick.yAxis
        }
    }
}
