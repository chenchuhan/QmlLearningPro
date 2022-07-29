import QtQuick          2.9
import QtQuick.Controls 2.5

Button {
    id:                         button
    checkable:                  false

    property alias  labelColor: _label.color
    property var    imageSource
    property color  _themeColor:   "#a27e7e"//"#FFDC35"//"#a27e7e"
    onCheckedChanged: checkable = false

    background: Rectangle {
        anchors.fill: parent
        color:  button.checked ?  "#a27e7e"/*_themeColor*/ : Qt.rgba(0,0,0,0)
        border.color: "black"
        border.width: button.checked ? 1 : 0
//        color:  button.checked ? "#FFDC35" : Qt.rgba(0,0,0,0)

    }

    contentItem: Row {
        spacing:                    10
        anchors.verticalCenter:     button.verticalCenter

        CCColoredImage {
            id:                     innerImage
            width:                  20
            height:                 width
            source:                 button.icon.source
            color:                  button.checked ?  "#black" : "black"
            visible:                imageSource !== ""
        }

        Text {
            id:                         _label
            visible:                    text !== ""
            text:                       button.text
            anchors.verticalCenter:     parent.verticalCenter
            color:                      button.checked ? "white" : "black"
            font.bold:                  true
            font.pointSize:             15
        }
    }
}
