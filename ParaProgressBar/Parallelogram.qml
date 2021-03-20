import QtQuick 2.12

Item {
    property real xs: 0                 // 水平方向切变
    property real ys: 0                 // 垂直方向切变
    property alias radius: rect.radius  // 圆角
    property alias text: title.text     // 文本
    property alias color: rect.color

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "lightblue"
        // 切变矩阵
        transform: Matrix4x4 {
            matrix: Qt.matrix4x4(1, xs, 0, 0,
                                 ys, 1, 0, 0,
                                 0, 0, 1, 0,
                                 0, 0, 0, 1)

        }

        Text {
            id: title
            anchors.centerIn: rect
            text: "0"
        }
    }
}
