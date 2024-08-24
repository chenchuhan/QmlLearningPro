import QtQuick 2.12
import QtQuick.Window 2.12

import QtQuick.Controls.Styles  1.4
import QtQuick.Controls         1.4
import QtQuick.Controls         2.12
import Ext.TC                   1.0
import QtQuick.Layouts          1.12

Window {
    visible: true
    width: 800
    height: 450
    title: qsTr("TableView!")

    TargetCoordinate {
        id: coordinateModel
    }

    property var normalG: Gradient {
        GradientStop { position: 0.0; color: "#11d3ac" }
        GradientStop { position: 1.0; color: "#F0F0F0" }
    }
    property var hoverG: Gradient {
        GradientStop { position: 0.0; color: "white"; }
        GradientStop { position: 1.0; color: "#d7e3bc"; }
    }
    property var pressG: Gradient {
        GradientStop { position: 0.0; color: "#d7e3bc"; }
        GradientStop { position: 1.0; color: "white"; }
    }

    Rectangle {
        id:                 rootRect
        anchors.top:        parent.top
        anchors.topMargin:  parent.height* 0.05
        anchors.horizontalCenter: parent.horizontalCenter
        width:              parent.width * 0.7
        height:             parent.height *0.7
        border.color:       "black"
        border.width:       2
        TableView {
            id: tableView
            anchors.margins:    10
            anchors.fill:       parent
            model:       coordinateModel
            //表格属性
            itemDelegate: {
                return editableDelegate;
            }
            rowDelegate: Rectangle {
                color : styleData.selected ? "#7db9f7" : (styleData.alternate ? "#f5f1f1":"#a89d9d")
                height: 30
            }

            TableViewColumn {
                role: "lng"   //来源于C++中roleNames
                title: "Longitude"
                resizable: true
            }

            TableViewColumn {
                role: "lat"   //y
                title: "Latitude"
//                width: 120
                resizable: true
            }

            TableViewColumn {
                role: "alt"   //
                title: "Altitude"
//                width: 120
                resizable: true
            }

            headerDelegate: Rectangle {
                implicitWidth: heardText.width
                implicitHeight: heardText.height * 1.6
                gradient:       styleData.pressed ? pressG : (styleData.containsMouse ? hoverG: normalG)
                border.width: 1
                border.color: "gray"
                Text {
                    id:     heardText
                    anchors.centerIn: parent
                    font.pixelSize: 22
                    text:           styleData.value
                    color:          styleData.pressed ? "red" : "blue"
                    font.bold: true
                }
            }
        }
    }

    ///--航点表格
    Component {
        id: editableDelegate
        Rectangle {
            border.color: "gray"
            border.width: 1
            Item{
//                anchors.fill: parent
                anchors.centerIn: parent
                height:  showTXT.height * 1.2
                width:   showTXT.width * 1.2

                Text {
                    id:showTXT
                    anchors.centerIn: parent
                    elide: styleData.elideMode
                    text: styleData.value !== undefined ? styleData.value : ""
                    color: styleData.selected ? "red" : "black"//styleData.textColor
                    font.pixelSize:  18
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    RowLayout {
        anchors.horizontalCenter:   rootRect.horizontalCenter
        anchors.top:                rootRect.bottom
        anchors.topMargin:          20
        Button {
            text:  "add"
            onClicked:      {

                console.log("tableView.currentRow ",tableView.currentRow)

                coordinateModel.insertRowsCoor(tableView.currentRow+1, 1);

                tableView.currentRow = tableView.currentRow + 1
                tableView.refreshTableView
            }
        }
        Button {
            text:  "delete"
            onClicked:      {
                if(tableView.rowCount ===0)  return

                if(tableView.currentRow === -1)    coordinateModel.removeRowsCoor(tableView.currentRow-1);
                else    coordinateModel.removeRowsCoor(tableView.currentRow);

                tableView.refreshTableView
            }
        }
    }
}
