import QtQuick                  2.12
import QtQuick.Controls         1.2

Item {

    property real leftX
    property real leftY

    property real rightX
    property real rightY

    Rectangle {
        id:                         dogRect
        width:                      (parent.width - 50)/2
        height:                     parent.height
        color:                      "#FFE6D9"
        border.width:               2
        border.color:               "black"

        property real imageCenter:  dogImage.width / 2
        property real moveX:        Math.max(Math.min(leftX*width - imageCenter,  width  - dogImage.width) , 0)
        property real moveY:        Math.max(Math.min(leftY*height - imageCenter, height - dogImage.height), 0)

        Image {
            id:                         dogImage
            mipmap:                     true
            fillMode:                   Image.PreserveAspectFit
            source:                     "/images/Dog.png"
            x:                          dogRect.moveX
            y:                          dogRect.moveY
        }
    }

    Rectangle {
        id:                         catRect
        width:                      (parent.width - 50)/2
        height:                     parent.height
        color:                      "#FFE6D9"
        anchors.left:               dogRect.right
        anchors.leftMargin:         50
        border.width:               2
        border.color:               "black"
        property real imageCenter: catImage.width / 2

        property real moveX:        Math.max(Math.min(rightX*width - imageCenter , width  - catImage.width) , 0)
        property real moveY:        Math.max(Math.min(rightY*height - imageCenter, height - catImage.height), 0)

        Image {
            id:                         catImage
            mipmap:                     true
            fillMode:                   Image.PreserveAspectFit
            source:                     "/images/Cat.png"
            x:                          catRect.moveX
            y:                          catRect.moveY
        }
    }
}

