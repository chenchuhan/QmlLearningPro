import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import com.example.OfficeExporter 1.0

Window {
    visible: true
    width: 640
    height: 480

    title: qsTr("Word Export Demo")

    OfficeExporter {
        id: exporter
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors.margins: 10

        // 表单标题
        Text {
            text: "请输入键值对:"
            font.pixelSize: 20
            anchors.horizontalCenter:  parent.horizontalCenter
        }

        // 键值对输入区
        ListView {
            id: listView
            anchors.horizontalCenter:  parent.horizontalCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ListModel {
                    ListElement { key: "[A]"; value: "柯布" }
                    ListElement { key: "[B]"; value: "阿瑟" }
                    ListElement { key: "[C]"; value: "杜拉" }
                    ListElement { key: "[D]"; value: "伊姆斯" }
                }

            delegate: RowLayout {
                spacing: 10
                TextField {
                    id: keyField
                    placeholderText: "键 (Key)"
                    text: model.key
                    Layout.fillWidth: true
                    onTextChanged: model.key = text
                }
                TextField {
                    id: valueField
                    placeholderText: "值 (Value)"
                    text: model.value
                    Layout.fillWidth: true
                    onTextChanged: model.value = text
                }
                Button {
                    text: "删除"
                    onClicked: model.remove(index)
                }
            }
        }

        // 添加键值对按钮
        Button {
            text: "添加键值对"
            Layout.alignment: Qt.AlignHCenter
            onClicked: listView.model.append({key: "", value: ""})
        }

        // 生成文档按钮
        Button {
            text: "选择模板并导出 Word 文档"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                dialog.open();
            }
        }

        Item {
            width: 1
            height: 1
        }
    }

    FileDialog {
        id:     dialog
        title:  "选择 Word 模板文件"
        selectExisting: true
        nameFilters: [ "Word 文档 (*.docx)", "All files (*)" ]
        onAccepted: {
            fileDialog.open();
        }
    }

    //templatePath.slice(8), 通常是为了去掉路径中的前缀部分，比如 file:///
    FileDialog {
        id: fileDialog
        title: "选择保存路径"
        selectExisting: false
        nameFilters: [ "Word 文档 (*.docx)", "All files (*)" ]
        onAccepted: {

            let data = {};
            for (let i = 0; i < listView.model.count; i++) {
                let item = listView.model.get(i);
                data[item.key] = item.value;
            }
            console.log("用户输入的键值对: ", JSON.stringify(data));

            var templatePath = dialog.fileUrl.toString();
            var filePath = fileUrl.toString();
            if (!filePath.endsWith(".docx")) {
                filePath += ".docx";
            }
            if ( exporter.createFromTemplate(templatePath.slice(8), filePath.slice(8), data)) {
                console.log("Word 文档已导出到：" + filePath);
            } else {
                console.log("导出失败");
            }
        }
    }
}
