import QtQuick.Window 2.12
import QtQuick                  2.12
import QtQuick.Controls         1.2

Item {
    id:                         _joyRoot

    ///--Input:
    property real   imageHeight: 10

    ///--Output：xAxis、yAxis、xPositionDelta、yPositionDelta
    property real   xAxis:                  0                   ///< Value range [-1,1], negative values left stick, positive values right stick
    property real   yAxis:                  0                   ///< Value range [-1,1], negative values down stick, positive values up stick
    property real   xPositionDelta:         0                   ///< Amount to move the control on x axis    ( [-50,50] )
    property real   yPositionDelta:         0                   ///< Amount to move the control on y axis    ( [-50,50] )

    property real   _centerXY:              width / 2
    property bool   _processTouchPoints:    false
    property color  _fgColor:               "black"
    property real   _hatWidth:              15
    property real   _hatWidthHalf:          _hatWidth / 2

    property real   stickPositionX:         _centerXY           //Value range [0,width]
    property real   stickPositionY:         _centerXY           //Value range [0,height]

    onWidthChanged:                     calculateXAxis()
    onStickPositionXChanged:            calculateXAxis()

    onHeightChanged:                    calculateYAxis()
    onStickPositionYChanged:            calculateYAxis()

    function calculateXAxis() {
        //xAxis =  ((stickPositionX / width) * 2 - 1)
        xAxis = stickPositionX / width
    }

    function calculateYAxis() {
        //yAxis =  (1 - (stickPositionY / height) * 2)
        yAxis = stickPositionY / height
    }

    ///--Release the thumb and return to the center position
    function reCenter() {
        _processTouchPoints = false

        // Move control back to original position
        xPositionDelta = 0
        yPositionDelta = 0

        // Re-Center sticks as needed
        stickPositionX = _centerXY
        stickPositionY = _centerXY
    }

    ///--Where the thumb is pressed, it is the center of the joystick
    function thumbDown(touchPoints) {
        // Position the control around the initial thumb position
        console.log("touchPoints[0].x",touchPoints[0].x)
        console.log("touchPoints[0].y",touchPoints[0].y)

        xPositionDelta = touchPoints[0].x - _centerXY    //[-50，50]
        yPositionDelta = touchPoints[0].y - _centerXY    //[-50，50]
        // We need to wait until we move the control to the right position before we process touch points
        _processTouchPoints = true
    }

    ///--stickPositionX = touchPoint.x ; stickPositionY = touchPoint.y
    Connections {
        target: touchPoint
        onXChanged: {
            if (_processTouchPoints) {
                _joyRoot.stickPositionX = Math.max(Math.min(touchPoint.x, _joyRoot.width), 0)
            }
        }
        onYChanged: {
            if (_processTouchPoints) {
                _joyRoot.stickPositionY = Math.max(Math.min(touchPoint.y, _joyRoot.height), 0)
            }
        }
    }

    ///--Multiple Point Touch Area,  core:  touchPoints
    MultiPointTouchArea {
        anchors.fill:           parent
        minimumTouchPoints:     1                   //only one
        maximumTouchPoints:     1                   //only one
        touchPoints:            [ TouchPoint { id: touchPoint } ]
        onPressed:              _joyRoot.thumbDown(touchPoints)
        onReleased:             _joyRoot.reCenter()

        //border visible
        Rectangle {
            border.color:       "#A6FFA6"//"#E8FFF5"
            border.width:       2
            color:              "transparent"
            anchors.fill:        parent
        }
    }

    ///--UI： inside circle + outer circle
    Rectangle {
        anchors.fill:       parent
        radius:             width / 2
        color:              "white"
        opacity:            0.7
        Rectangle {
            anchors.margins:    parent.width / 4
            anchors.fill:       parent
            radius:             width / 2
            border.color:       _fgColor
            border.width:       2
            color:              "transparent"
        }
        Rectangle {
            anchors.fill:       parent
            radius:             width / 2
            border.color:       _fgColor
            border.width:       2
            color:              "transparent"
        }
    }

    ///--UI:  Up Down Left Right
    Image {
        height:                     imageHeight
        width:                      height
        sourceSize.height:          height
        mipmap:                     true
        fillMode:                   Image.PreserveAspectFit
        source:                     "/images/Up.svg"
        anchors.top:                parent.top
        anchors.topMargin:          5
        anchors.horizontalCenter:   parent.horizontalCenter
    }
    Image {
        height:                     imageHeight
        width:                      height
        sourceSize.height:          height
        mipmap:                     true
        fillMode:                   Image.PreserveAspectFit
        source:                     "/images/Down.svg"
        anchors.bottom:             parent.bottom
        anchors.bottomMargin:       5
        anchors.horizontalCenter:   parent.horizontalCenter
    }
    Image {
        height:                     imageHeight
        width:                      height
        sourceSize.height:          height
        mipmap:                     true
        fillMode:                   Image.PreserveAspectFit
        source:                     "/images/Left.svg"
        anchors.left:               parent.left
        anchors.leftMargin:         5
        anchors.verticalCenter:     parent.verticalCenter
    }
    Image {
        height:                     imageHeight
        width:                      height
        sourceSize.height:          height
        mipmap:                     true
        fillMode:                   Image.PreserveAspectFit
        source:                     "/images/Right.svg"
        anchors.right:              parent.right
        anchors.rightMargin:        5
        anchors.verticalCenter:     parent.verticalCenter
    }

    ///--UI: touch points
    Rectangle {
        width:          _hatWidth
        height:         _hatWidth
        radius:         _hatWidthHalf
        border.color:   _fgColor
        border.width:   1
        color:          Qt.rgba(_fgColor.r, _fgColor.g, _fgColor.b, 0.5)
        x:              stickPositionX - _hatWidthHalf                  //By default the middle
        y:              stickPositionY - _hatWidthHalf                  //By default the middle
    }
}

