import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Layouts          1.2

TextField {
    id:                 root
    textColor:          "#000000"
    activeFocusOnPress: true
    antialiasing:       true
    width:              150

    //点击输入框，则全选
    Component.onCompleted: selectAllIfActiveFocus()
    onActiveFocusChanged:  selectAllIfActiveFocus()
    function selectAllIfActiveFocus() {
        if (activeFocus) {
            selectAll()
        }
    }

    style: TextFieldStyle {
        id:                  tfs
        font.pointSize:      13
        font.family:         "Microsoft Yahei"
        renderType:          Text.QtRendering   // 渲染方式 This works around font rendering problems on windows

        background: Item {
            id: backgroundItem
            Rectangle {
                anchors.fill:           parent
                anchors.bottomMargin:   -2
                color:                  "#44ffffff"   //边距的填充  可以用 green 测试
            }

            Rectangle {
                anchors.fill:           parent
                border.width:           2//enabled ? 2 : 0
                border.color:           enabled ? (root.activeFocus ? "#47b" : "#999" ) : "#E0E0E0"
                color:                  "#ffffff"                //qgcPal.textField 边距的填充  可以用 red 测试
                radius:                 height *0.1
            }
        }
    }
}
