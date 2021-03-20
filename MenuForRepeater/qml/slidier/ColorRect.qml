import QtQuick 2.3

Item {
    property real value;

    id: root
    //[重点1]：clip, 当元素的子项超出父项范围后会自动裁剪，也就是子项超出了范围就剪切掉，不让他显示和起作用
    //在此中，限定在距离parent的54的范围内，默认为false
    clip:           true
    anchors.fill:   parent
    anchors.margins: 54;

    Item {
        width:  root.width
        height: root.height * 3;
        anchors.centerIn: parent
        Rectangle {
            id: _top
            anchors.fill: parent
            smooth: true
            antialiasing: true
            gradient: Gradient {
                GradientStop { position: 0; color: "green" }
                GradientStop { position: 0.5;  color: "aqua" }
            }
        }
        Rectangle {
            id: _bottom
            height: _top.height / 2
            anchors {
                left:   _top.left;
                right:  _top.right;
                bottom: _top.bottom
            }
            smooth: true
            antialiasing: true
            gradient: Gradient {
                GradientStop { position: 0.0;  color: "yellow"  }
                GradientStop { position: 1; color: "orange" }
            }
        }
        //蓝绿面板的上下平移
        transform: Translate{
            y:  value         //Y轴方向的偏移量
        }
    }
}
