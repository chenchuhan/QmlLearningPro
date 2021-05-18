import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4


Window {
    id: root
    visible: true
    width: 400
    height: 200
    title: qsTr("Canvas For Sector")

    //currentValue:   0%~100%
    property real currentValue : 0
    //angle:         180°~360°   //180°为100份
    property real angle: (currentValue * 180 / 100 + 180)

    onCurrentValueChanged: _canvas.requestPaint();

    Canvas{ ///画布
        id: _canvas

        width: 200
        height: 200
        anchors.margins: 50
        anchors.centerIn: parent

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

        function paintPer(ctx,x,y, r, startAngle,endAngle, color) {

            ctx.fillStyle = color
            ctx.save();         //ctx.save() 和 ctx.restore(); 搭配使用是清除画板的
            ctx.beginPath();
            ctx.moveTo(x,y);
            ctx.arc(x,y,r,startAngle*Math.PI/180, endAngle*Math.PI/180);
            ctx.closePath();
            ctx.fill()
            ctx.restore();
        }

        onPaint: {
            var ctx = getContext("2d");  ///画师
            //外层底图
            paintPer(ctx,100,100,100,180,360,'grey')
            //外层动图：  angle就是显示的目标角度
            paintPer(ctx,100,100,100,180,angle,'black')
            //中间空白层
            paintPer(ctx,100,100,75,0,360,"white")
            //内层底图
            paintPer(ctx,100,100,66,180,360,'#EEE8CD')
            //内层动图 angle就是显示的目标角度
            paintPer(ctx,100,100,66,180,angle,'#EEB422')
            //内层空白层
            paintPer(ctx,100,100,63,0,360,"white")
        }

        //可以文字，可以图片
        Text {
            id: txt_progress
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 26  //16
            font.bold:      true

            text: currentValue.toString() + "%"
            color: 'black'
        }
    }
}


