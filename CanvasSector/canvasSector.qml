import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4


Window {
    id: root
    visible: true
    width: 400//200
    height: 200//100
    title: qsTr("Hello World")

    property int cnt: 0
    property real currentValue : 0
    property real angle: (currentValue * 180 / 100 + 180)



    Button {
        id: btn;
        visible: false
//        //[布局]：
//        anchors.right:  txt.right;
//        anchors.top: txt.bottom;
        anchors.topMargin: 8;           //上边距留白8

        text: "A Button";
        onClicked: {
            cnt++;
            console.log("clicked");      //输出日志
            _canvas.requestPaint();
//            if(cnt%2)
//            {
//                _canvas.visible = false;
//            }
//            else
//            {
//                 _canvas.visible = true;
//            }
        }
    }
//    //将原点移到100,100的位置

    onCurrentValueChanged: _canvas.requestPaint();


    Canvas{ ///画布
        id: _canvas

        width: 200
        height: 100

//        width: 200
//        height: 200
//        anchors.margins: 50
//        anchors.centerIn: parent


        Timer{
            id: timer
            interval: 20;
            running: true;
            repeat:     true;
            onTriggered: {
                if(currentValue === 100) {
                    currentValue = 0;
                }
                currentValue += 1;
            }
        }

        contextType:  "2d";

        function paintGimbalYaw(ctx,x,y,r,angle1,angle2,color) {

//                ctx.translate(x, y);
//                ctx.arc(0,0,x, angle1*Math.PI/180, angle2*Math.PI/180);
//                ctx.stroke();

            ctx.fillStyle = color
            ctx.save();
            ctx.beginPath();
            ctx.moveTo(x,y);
            ctx.arc(x,y,r,angle1*Math.PI/180,angle2*Math.PI/180);
            ctx.closePath();
            ctx.fill()
            ctx.restore();
//           ctx.stroke();  //外框
//            ctx.fill();  //填充
        }

        onPaint: {
            var ctx = getContext("2d");  ///画师

            paintGimbalYaw(ctx,100,100,100,180,360,'#005840')
            paintGimbalYaw(ctx,100,100,100,180,angle,'#01E9A9')
            paintGimbalYaw(ctx,100,100,75,0,360,"white")

            paintGimbalYaw(ctx,100,100,66,180,360,'#005840')
            paintGimbalYaw(ctx,100,100,66,180,angle,'#01E9A9')
            paintGimbalYaw(ctx,100,100,63,0,360,"white")
        }

        //文字
//        Text {
//            id: txt_progress
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 100
//            anchors.horizontalCenter: parent.horizontalCenter

//            font.pixelSize: 26  //16
//            font.bold:      true

//            text: currentValue.toString() + "%"
//            color: '#01E9A9'
//        }

        Image {
            anchors.bottom:             parent.bottom
            anchors.bottomMargin:       100
            anchors.horizontalCenter: parent.horizontalCenter

            source:                     "/images/Oil2.svg"
            fillMode:                   Image.PreserveAspectFit
//            sourceSize.width:           10
        }
    }
}


