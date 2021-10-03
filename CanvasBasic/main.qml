import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4

Window {
    visible: true
    width: 400
    height: 400
    title: qsTr("Hello World!!!")

    Button {
        id: btn;

        text: "A Button";
        onClicked: {
            var a = 99
            var b = Math.sqrt(a)
            console.log("b:",b);      //输出日志
            _canvas.requestPaint();
        }
    }

    Canvas{ ///画布
        id: _canvas
        width: 400
        height: 400

        contextType:  "2d";
        onPaint: {
            var ctx = getContext("2d");  ///画师
            ctx.fillStyle = "red"
            ctx.strokeStyle = "blue";
            ctx.lineWidth =5;

            ctx.save();
            ctx.beginPath();
//            ctx.moveTo(width/4,height);  //起始角度顺时钟数                    false 顺
            ctx.arc(width/2, height/2, 50, 273*Math.PI/180, 267*Math.PI/180, true);
//            ctx.closePath();
//            ctx.fill()
            ctx.stroke();

//            var ctx = getContext("2d");  ///画师
//            ///--------------------------6.路径结合--------------------------
//            ctx.lineWidth =2;
//            ctx.strokeStyle = "red";
//            //新增，  font表示一串字符串 sans-serif西文中没有衬线的字体，与汉字字体中的黑体相对应
//            ctx.font = " 42px sans-serif"
//            var gradient = ctx.createLinearGradient(0,0,width,height);//前两个是坐标，后两个是对角的坐标
//            gradient.addColorStop(0.0, Qt.rgba(1,0,0,1.0));
//            gradient.addColorStop(1.0, Qt.rgba(0,0,0,1.0));
//            ctx.fillStyle = gradient;
//            ctx.beginPath();
//            ctx.moveTo(4,4);
//            ///---使用(cp1x, cp1y)和(cp2x, cp2y)指定的控制点在当前位置和给定端点之间添加一条三次贝塞尔曲线。
//            ///在添加曲线之后，当前位置被更新为在曲线的端点(x, y)处。下面的代码生成如下所示的路径:
//            //             (real cp1x, real cp1y, real cp2x, real cp2y, real x, real y)
////            ctx.bezierCurveTo(0, height-1, width-1, height/2, width/4, height/4);
////            ctx.lineTo( width/2, height/4);     //绘线到某个坐标
//            ctx.arc(width*5/8, height/4, width/8, Math.PI ,0, false);
////            ctx.ellipse(width*11/16, height/4, width/8,height/4);
////            ctx.lineTo(width/2, height/8);
////            ctx.text("Complex", width/4,height*7/8);

//            ctx.fill();
//            ctx.stroke();
        }
    }
}
