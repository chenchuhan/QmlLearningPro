import QtQuick 2.2
import QtQuick.Window 2.1

Window {
    property int _pix: 16
    property int _margin: 10
    property real _defaultSilderValue
    property int oldHeight: container.height;
    width: 300; height: 300
    visible: true;

    Rectangle {
        anchors.fill: parent;
        color: "lightGray"

        ColorRect {
            id: colorRect
            anchors.centerIn: parent
            //[重点1]: 因为需要小滑块处于正中间，且正中间的值为0
            value :   slider.y - _defaultSilderValue;
        }

        //滑块条
        Rectangle {
            id: container
            anchors {
                top: parent.top;
                topMargin: _margin * 2;
                bottom: parent.bottom;
                bottomMargin: _margin *2;
                right: parent.right;
                rightMargin: _margin
            }
            width: _pix
            radius: width/2;
            opacity: 0.6            //不透明度
            antialiasing: true      // 抗锯齿
            //黑色——>棕色的渐变
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 1.0; color: "brown" }
            }

            //[重点2]:当面板放大放小的时候，需要保持滑块的比例不变
            onHeightChanged: {
                if(height <= slider.height){
                    slider.height = height;      //小滑块高度  =  滑道高度
                }
                else  {
                    slider.height = _pix*2;      //小滑块高度  =  固定高度
                    var _scale =  (height -  _pix*2) / (oldHeight -  _pix*2)
                    //比列尺 * 之前的实际距离
                    slider.y =  slider.y * _scale;
                    oldHeight = height;
                    //[重点3]默认中间值，也会随着长宽拖动而变化的。
                    _defaultSilderValue = height/2-_pix;
                }
            }
            //小滑块条
            Rectangle {
                id: slider
                x: 1; y: container.height/2-_pix;    //y轴向向下为负, 默认滑块放中间
                width: _pix-2;  height: _pix*2  ;
                radius: width/2;
                antialiasing: true
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "green" }
                    GradientStop { position: 1.0; color: "aqua" }
                }
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -_pix
                    drag.target: parent;
                    drag.axis: Drag.YAxis
                    drag.minimumY: 1;
                    drag.maximumY: container.height - slider.height-1;
                }
            }
        }
    }
}
