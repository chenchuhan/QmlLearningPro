//Demo.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Window 2.12

import cc.FermatSpiralPath 1.0

Window {
    visible: true
    width: 640 * 1.5
    height: 480 * 1.5
    title: qsTr("螺旋曲线")

    readonly property var  coordinateHome: QtPositioning.coordinate(30.6562, 104.0657)

    FermatSpiralPath {
        id: fsPath
    }

    Map {
        id: the_map
        anchors.fill: parent
        minimumZoomLevel: 4
        maximumZoomLevel: 20
        zoomLevel: 17
        center:         coordinateHome

        plugin: Plugin {
            name: "esri" //"esri" "mapbox" "osm" "here"
        }

        //显示缩放等级与center
        Rectangle{
            anchors{
                left: the_map.left
                bottom: the_map.bottom
                margins: 10
            }
            width: content.width+20
            height: content.height+10
            Text {
                id: content
                x: 10
                y: 5
                font.pixelSize: 14
                text: "Zoom Level "+Math.floor(the_map.zoomLevel)+" Center:"+the_map.center.latitude+"  "+the_map.center.longitude
            }
        }

        MapPolyline {
            line.width: 5
            line.color: 'green'
            path:       fsPath.points
        }
    }

    Rectangle {
        anchors.top:            parent.top
        anchors.topMargin:  10
        anchors.horizontalCenter: parent.horizontalCenter
        width: grid.width + 10
        height: grid.height + 10
        color:  "black"
        radius: 4

        Grid {
            id: grid
            anchors.centerIn: parent
            rows:    2
            columns: 2
            rowSpacing: 4
            columnSpacing: 4
            horizontalItemAlignment:    Grid.AlignHCenter
            verticalItemAlignment:      Grid.AlignVCenter

            Label {
                id:                         radiusLabel
                color:                      "#B7FF4A"
                text:                       qsTr("输入半径：")
                font.pointSize:             11
                font.bold:                  true
            }
            TextField {
                id:                         radiusTF
                font.family:                "微软雅黑"
                width:                      radiusLabel.width
                verticalAlignment:          Text.AlignVCenter
                inputMethodHints:           Qt.ImhFormattedNumbersOnly  //只允许数字输入，包括小数点和负号
                focus:                      true
                placeholderText:            qsTr("60")
                color:                      "red"
                selectByMouse:              true                        //可以选择文本
                validator:                  IntValidator {bottom: 1; top: 100000;}
                onEditingFinished: {
                    fsPath.radius = Number(text)
                }
            }

            Label {
                id:                         spacingLabel
                text:                       qsTr("输入间距：")
                font.pointSize:             11
                font.bold:                  true
                color:                      "#B7FF4A"
            }

            TextField {
                id:                         spacingTF
                verticalAlignment:          Text.AlignVCenter
                font.family:                "微软雅黑"
                width:                      radiusTF.width
                selectByMouse:              true
                focus:                      true
                placeholderText:            qsTr("20")
                color:                      "red"
                validator:                  IntValidator {bottom: 1; top: Number(radiusTF.text);}

                onEditingFinished: {
                    fsPath.spacing = Number(text);
                }
            }
        }
    }
}
