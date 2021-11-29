//Demo.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12

import QtQuick.Window 2.12

//地图自定义
Window {
    id: control

    visible: true
    width: 640
    height: 480
    title: qsTr("Crazy Math")

    //地图的模式
    // 0:普通浏览
    // 1:测距
    property int mapMode: 0
    property Getdistance currentRuler: null

    property alias map: the_map

    onMapModeChanged: {
        console.log("map mode",mapMode);
        if(control.mapMode!=1&&currentRuler){
            currentRuler.closePath();
            currentRuler=null;
        }
    }

    //缩放等级，维度，精度
    function viewPoint(zoomLevel,latitude,longitude){
        the_map.zoomLevel=zoomLevel;
        the_map.center=QtPositioning.coordinate(latitude, longitude);
    }




//        clip: true

        Row{
            RadioButton{
                text: "Normal"
                checked: true
                onCheckedChanged: if(checked) control.mapMode=0;
            }
            RadioButton{
                text: "Ruler"
                onCheckedChanged: if(checked) control.mapMode=1;
            }
        }

        Map {
            id: the_map
            anchors.fill: parent
            anchors.topMargin: 40
            minimumZoomLevel: 4
            maximumZoomLevel: 16
            zoomLevel: 10
            center: QtPositioning.coordinate(30.6562, 104.0657)

            plugin: Plugin {
                name: "esri" //"esri" "mapbox" "osm" "here"
            }

            //显示缩放等级与center
            Rectangle{
                anchors{
                    left: the_map.left
                    bottom: the_map.bottom
                    margins: 5
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

            MouseArea{
                id: map_mouse
                anchors.fill: parent
                enabled: control.mapMode!=0

                //画了一个点后跟随鼠标，除非双击
                hoverEnabled: true
                onClicked: {
                    // 1 测距
                    if(control.mapMode===1){
                        if(!currentRuler){
                            currentRuler=ruler_comp.createObject(the_map);
                            if(currentRuler)
                                the_map.addMapItemGroup(currentRuler);
                        }
                        if(currentRuler){
                            var coord=the_map.toCoordinate(Qt.point(mouseX,mouseY),false);
                            currentRuler.appendPoint(coord);
                        }
                    }
                }
                onDoubleClicked: {
                    // 1 测距
                    if(control.mapMode===1){
                        if(currentRuler){
                            currentRuler.closePath();
                            currentRuler=null;
                        }
                    }
                }
                onPositionChanged: {
                    // 1 测距
                    if(control.mapMode===1){
                        if(currentRuler){
                            var coord=the_map.toCoordinate(Qt.point(mouseX,mouseY),false);
                            currentRuler.followMouse(coord);
                        }
                    }
                }
            }
        }

        Component{
            id: ruler_comp
            Getdistance{

            }
        }
    }

