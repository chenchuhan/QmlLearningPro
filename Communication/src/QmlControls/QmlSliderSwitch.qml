

import QtQuick                  2.3
import QtQuick.Controls         1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0
import QGroundControl.SGControls    1.0

/// The SliderSwitch control implements a sliding switch control similar to the power off
/// control on an iPhone.

//SGSliderSwitch {
//    Layout.columnSpan:       2
//    Layout.preferredWidth:  _comboFieldWidth
//    _sliderWidth:           ScreenTools.isMobile ? _comboFieldWidth * 0.7 : _comboFieldWidth * 0.7
//    color:                  qgcPal.windowShade

//}

Rectangle {
    id:             _root
    implicitWidth:  column.width + 10*2
    implicitHeight: column.height + 10*2
    radius:         12
//    color:          "black"//qgcPal.windowShade
//    border.color:   "black"
//    border.width:   1


    property real  _sliderWidth

    ///----内部使用：
    property real   sgPointSize:   QGroundControl.corePlugin.sgPointSize

    function getPointSize(pz) {
        switch(pz) {
            case 8:
                return "小"
            case 9:
                return "中"
            case 10:
                return "标准"
            case 11:
                return "大"
            default:
                return "标准"
        }
    }

    function getSlider(x) {
        if(x <= sliderBig._border) {
            sliderBig._ps = 8
            sliderBig._index = 0
        } else if(x <= (sliderBig._border + sliderBig._wd * 1)) {
            sliderBig._ps = 9
            sliderBig._index = 1
        } else if(x <= (sliderBig._border + sliderBig._wd * 2)) {
            sliderBig._ps = 10
            sliderBig._index = 2
        } else if(x <= (sliderBig._border + sliderBig._wd * 3)) {
            sliderBig._ps = 11
            sliderBig._index = 3
        }

        sliderDot.x = sliderBig._border + sliderBig._wd * sliderBig._index
        QGroundControl.corePlugin.sgPointSize = sliderBig._ps
    }

    function getClick(x) {
        if(       x <= sliderBig._border  + sliderBig._wd*(0+0.333)) {
            sliderBig._ps = 8
            sliderBig._index = 0
        } else if(x <= (sliderBig._border + sliderBig._wd*(1+0.333))) {
            sliderBig._ps = 9
            sliderBig._index = 1
        } else if(x <= (sliderBig._border + sliderBig._wd*(2+0.333))) {
            sliderBig._ps = 10
            sliderBig._index = 2
        } else if(x <= (sliderBig._border + sliderBig._wd*(3+0.333))) {
            sliderBig._ps = 11
            sliderBig._index = 3
        }

        sliderDot.x = sliderBig._border + sliderBig._wd * sliderBig._index
        QGroundControl.corePlugin.sgPointSize = sliderBig._ps
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    Column {
        id:                         column
        spacing:                    ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight/4 : ScreenTools.defaultFontPixelHeight/2      //* 0.5
        anchors.centerIn:           parent

//        SGLabel {
//            id:                         textLabel1
//            text:                       qsTr("字体大小:") + getPointSize(sgPointSize) + "(" + sgPointSize + ")"
//            font.family:                ScreenTools.demiboldFontFamily
//            anchors.horizontalCenter:   parent.horizontalCenter
//            color:                      "white"//qgcPal.sgTheme//"#FFA042"//
//            font.pointSize:             12
//        }

        QGCLabel {
            text:                           qsTr("字体大小:") + getPointSize(sgPointSize) + "(" + sgPointSize + ")"
            anchors.left:                   parent.left
        }

        Row {
            id:                         row
            spacing:                    5

            //左字体
            QGCColoredImage {
                source:                 "/qmlimages/SG/Font.svg"
                color:                  "white"
                anchors.verticalCenter: parent.verticalCenter
                height:                 sliderBig.height
                width:                  height * 1.0
            }

            //大框
            Rectangle {
                id:                     sliderBig
                width:                  _sliderWidth/*ScreenTools.isMobile ? 300*1.4 : 300*/
                height:                 ScreenTools.isMobile ? 20 * 2  :  22//24//20//28//16//20
                radius:                 height /2
                color:                  "grey"//qgcPal.windowShade
                anchors.verticalCenter: parent.verticalCenter

                property real _border:  ScreenTools.isMobile ? 10 : 5        //小原点 上下左右边界
                property real _diameter: height - (_border * 2)  //直径
                property real _wd:      (width-sliderBig._border*2-sliderBig.children[0].width)/(rpt.count-1)
                property real _ps :     7
                property int  _index:   0

                //小框，分隔
                Repeater {
                    id:                 rpt
                    model:              4
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        x:                      sliderBig._border + sliderBig._wd * index
                        height:                 parent.height * 0.5
                        width:                  height
                        radius:                 width/2
                        color:                  "#5B5B5B"
                    }
                }

                //小框
                Rectangle {
                    id:         sliderSmall
                    height:     parent.height
                    radius:     parent.radius
                    width:      sliderDot.x + sliderBig._diameter + sliderBig._border
                    color:      qgcPal.sgButton         //"#FFA042" 鸿蒙橙
                }

                ///--小滑块是个圆
                Rectangle {
                    id:         sliderDot
                    y:          sliderBig._border
                    height:     sliderBig._diameter
                    width:      sliderBig._diameter
                    radius:     sliderBig._diameter / 2
                    color:      "white"

                    //确定在哪一格
                    Component.onCompleted: {

                        if(sgPointSize == 8) {
                            sliderBig._index = 0
                        } else if(sgPointSize == 9) {
                            sliderBig._index = 1
                        } else if(sgPointSize == 10) {
                            sliderBig._index = 2
                        } else if(sgPointSize == 11) {
                            sliderBig._index = 3
                        }

//                        console.log("sgPointSize",sgPointSize)
//                        console.log("sliderBig._index",sliderBig._index)
                        sliderDot.x = sliderBig._border + sliderBig._wd * sliderBig._index
                    }

                    onXChanged: {
                        getSlider(x);
                    }
                }

                QGCMouseArea {
                    id:                 sliderDragArea
                    fillItem:           parent//sliderDot
                    drag.target:        sliderDot
                    drag.axis:          Drag.XAxis
                    drag.minimumX:      sliderBig._border
                    drag.maximumX:      _maxXDrag
                    preventStealing:    true

                    property real _maxXDrag:    sliderBig.width - (sliderBig._diameter + sliderBig._border)

                    onClicked : {
                        getClick(mouse.x);
                    }
                }
            }

            ///右字体
            QGCColoredImage {
                source:                 "/qmlimages/SG/Font.svg"
                color:                  "white"
                anchors.verticalCenter: parent.verticalCenter
                height:                 sliderBig.height * 1.2
                width:                  height
            }
        }
    }
}

