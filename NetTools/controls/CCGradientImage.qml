import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.12      ///--[Mark]

LinearGradient
{
    id:                         image
    width:                      height

    property alias iconSource:              innerImage.source

    property real  _startPos:       0.0
    property color _startColor:     "white"

    property real  _middlePos:      (1-0.618)
    property color _middleColor:    "white"

    property real  _stopPos:        1.0
    property color _stopColor:      qgcPal.ccTheme

    source: Image {
        id:                 innerImage
        mipmap:             true
        antialiasing:       true
        fillMode:           Image.PreserveAspectFit
    }

    gradient: Gradient {    //从上到下的
        GradientStop {
            position:   _startPos
            color:      _startColor
        }

        GradientStop {
            position:   _middlePos
            color:      _middleColor
        }

        GradientStop {
            position:   _stopPos
            color:      _stopColor
        }
    }
    start:Qt.point(0,0)
    end:Qt.point(0,height)
}

