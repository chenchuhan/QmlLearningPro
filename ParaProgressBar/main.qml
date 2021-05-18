import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Window {
    visible: true

    width: 600
    height: 220
    title: qsTr("不一样的进度条！")
    color: "#404040"

    property int showIndex: 0  //lightblue
    property int _pix:      20
    property int sliderMax: container.width - slider.width-1

    onShowIndexChanged: {
        for(var i=0; i<15; i++) {
            if (row.children[i].toString().startsWith("Parallelogram")) {
                if(i<showIndex) {
                    row.children[i].color = "lightblue"
                }
                else {
                    row.children[i].color = "white"
                }
            }
        }
    }

    Row {
        id:  row
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        spacing: 4

        Repeater {
            id: rep
            model: 15

            Parallelogram {
//                xs:  -0.5  //-原本0.6
                xs:  -1  //-原本0.6
                ys:  0.01
                radius: 3
                width: 28
                color:    "white"
                height: 10 + (28-10) * (15-index) / 15
                anchors.bottom: parent.bottom
//                anchors.bottomMargin: -index
                text: index + 1
                }
        }
    }

    Rectangle {
        id: container
        anchors {
            top: row.bottom
            topMargin: 30
            left: row.left
            leftMargin: -10
        }
        width:                  row.width
        height:                 _pix
        radius:                 height/2;
        opacity: 0.6                                //不透明度
        antialiasing: true                          // 抗锯齿，具体效果见下面图片
        //渐变色
        gradient: Gradient {
            GradientStop { position: 0.0; color: "White" }
            GradientStop { position: 1.0; color: "LightSalmon" }
        }

        //小滑块条
        Rectangle {
            id: slider
            x: 0
            y: 2
            width:              _pix*2;
            height:             _pix-4
            radius:             height/2;
            antialiasing: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: "green" }
                GradientStop { position: 1.0; color: "aqua" }
            }
            MouseArea {
                anchors.fill: parent
                anchors.margins: -_pix
                drag.target: parent;
                drag.axis: Drag.XAxis
                drag.minimumX: 1;
                drag.maximumX: sliderMax;
            }
            //滑块变动，影响 showIndex 的变化
            onXChanged:{
                showIndex = 15*x/(sliderMax)
            }
        }
    }

    Button {
        id: sub
        text: "SUB"
        anchors.top:    container.bottom
        anchors.topMargin: 20
        anchors.left:   container.left

        onClicked:  {
            showIndex--
            if(showIndex <= 0) showIndex=0;
            slider.x = showIndex * sliderMax / 15
        }
    }
    Button {
        text: "ADD"
        anchors.top:    container.bottom
        anchors.topMargin: 20
        anchors.left:   sub.right
        anchors.leftMargin: 20

        onClicked: {
            showIndex++
            if(showIndex >= 15) showIndex=15;
            slider.x = showIndex * sliderMax / 15
        }
    }
}
