import QtQuick          2.9
import QtQuick.Controls 2.5

Button {
    id:                         button
    height:                     20
    leftPadding:                4
    rightPadding:               4
    checkable:                  false

    property alias  labelColor: _label.color

    onCheckedChanged: checkable = false

    background: Rectangle {
        anchors.fill: parent
        color:  button.checked ? "#FFDC35" : Qt.rgba(0,0,0,0)
    }

    contentItem: Row {              //可修改为Column
        spacing:                    10
        anchors.verticalCenter:     button.verticalCenter

        ColoredImage {
            id:                     innerImage
            width:                  20
            height:                 width
            source:                 button.icon.source
            color:                  button.checked ?  "#007979" : "black"
        }

        Text {
            id:                         _label
            visible:                    text !== ""
            text:                       button.text
            anchors.verticalCenter:     parent.verticalCenter
            color:                      button.checked ? "#007979" : "black"
            font.bold:                  true
            font.pointSize:             15
        }
    }
}
