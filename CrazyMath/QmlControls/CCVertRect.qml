import QtQuick                  2.12
import QtQuick.Controls         2.12

import QmlControls  1.0

Rectangle {
    height:                         column.height + 20
    width:                          height
    radius:                         width/2

    //图像
    property alias imageSource :    image.source
    property alias imageColor:      image.color

    //文本
    property alias  text:           label.text
    property alias  fontPointSize:  label.font.pointSize
    property alias  textColor:      label.color

    Column {
        id:                         column
        anchors.centerIn:           parent
        spacing:                    0

        CCColoredImage {
            id:                     image
            anchors.horizontalCenter: parent.horizontalCenter
            width:                  60
            height:                 width
        }

        CCLabel {
            id:                     label;
            color:                  'white'
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
