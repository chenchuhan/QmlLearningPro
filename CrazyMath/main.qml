import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import QmlControls  1.0
import cc.Values    1.0

Window {
//-------------------------------------第三个版本 v1.0 -----------------------------------
    id:     mainRoot
    visible: true
    width: 640
    height: 480
    title: qsTr("Crazy Math")


    color:    themeColor                // "#4F4F4F"//"#9D9D9D"//"#d0d0d0"//"#84C1FF"

    property int  viewSwitch:       gameStartView

    readonly property int bigFontPoint:         25

    //color
    readonly property color themeColor:          rgb(77,165,166)  //
    readonly property color subColor:            rgb(110,210,210)  //
    readonly property color bgColor:                "#4F4F4F"
    readonly property color bgLightColor:           "#6C6C6C"

    readonly property color textColor:             "white"


    readonly property int gameStartView:        1
    readonly property int gameContentView:      2
    readonly property int gameOverView:         3

    property int  currentScore:     0

    Values {
        id: values
    }

    ///十进制 转 十六进制
    function rgb(r, g, b){
           var ret = (r << 16 | g << 8 | b)
           return ("#"+ret.toString(16)).toUpperCase();
       }

    function gameStart() {
        viewSwitch = gameContentView
        currentScore = 0    //分数清零
        gameNext();
    }

    function gameNext() {
        timerText.restart()
        mathText.text = MathProblem.nextMath();
    }

    function gameOver() {
        scors.text = currentScore

        values.bestScore = Math.max(values.bestScore, currentScore)
        best.text = values.bestScore

        viewSwitch = gameOverView
        timerText.timerOver()
        gameoverAnimation.stop()
        gameoverAnimation.start()
    }

    ///1. 游戏开始界面
    Column {
        id:                         startView
        visible:                    viewSwitch === gameStartView
        anchors.centerIn:           parent
        spacing:                    40

        CCHoverHorzButton {
            text:                   qsTr("Start")
            imageSource:            "/images/Start.svg"
            fontPointSize:          bigFontPoint
            onClicked:              gameStart()
        }
    }

    ///2. 游戏中界面
    function checkAnswer(b) {
        if(b === MathProblem.isRight) {
            //回答正确
            currentScore = currentScore + 10 + (timerText.ms /1000 ).toFixed(0) * 5
            gameNext()
        }
        else {
            gameOver()
        }
    }
    Column {
        visible:                    viewSwitch === gameContentView
        anchors.centerIn:           parent
        spacing:                    30

        CCVertRect {
            id:                     timerText;
            imageSource:            "/images/Clock.svg"
            fontPointSize:          bigFontPoint
            color:                  bgColor
            imageColor:             subColor
            textColor:              textColor
            text :                  (ms/10).toFixed(0)
            anchors.horizontalCenter: parent.horizontalCenter

            property int ms: 4000

            Timer {
                id: timer;
                interval: 10   //10ms
                repeat: true
                onTriggered:  {
                    timerText.ms = timerText.ms - 10
                    if(timerText.ms <= 0) {
                        gameOver()
                    }
                }
            }

            function timerOver() {
                ms = 4000  //
                timer.stop()
            }

            function restart() {
                ms = 4000
                timer.start()
            }
        }

        Rectangle {
            width:               mathText.width + 20
            height:              mathText.height + 10
            radius:              height/4
            color:               bgLightColor
            anchors.horizontalCenter: parent.horizontalCenter

            CCLabel {
                id:                     mathText;
                color:                  "white"
                font.pointSize:         bigFontPoint
                font.bold:              true
                anchors.centerIn:       parent
            }
        }

        Row {
            spacing:                    20
            anchors.horizontalCenter: parent.horizontalCenter
            CCHoverHorzButton {
                text:                   qsTr("Correct")
                imageSource:            "/images/Correct.svg"
                onClicked:              checkAnswer(true)
            }
            CCHoverHorzButton {
                text:                   qsTr("Error")
                imageSource:            "/images/Error.svg"
                onClicked:              checkAnswer(false)
            }
        }
    }

    ///3. 游戏结束界面
    Column {
        id:                         gameoverColumn
        visible:                    viewSwitch === gameOverView
        y:                          (parent.height - gameoverColumn.height)/2 //parent.height * 0.2
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    20
        CCLabel {
            id:                         gameoverText
            font.pointSize:             28
            font.bold:                  true                     //黑体
            text:                       qsTr("Game Over!!!")
            anchors.horizontalCenter:   parent.horizontalCenter
        }
        Row {
            anchors.horizontalCenter:   parent.horizontalCenter

            CCLabel {
                font.pointSize:             20
                font.bold:                  true                     //黑体
                text:                       qsTr("Score:")
                anchors.verticalCenter:    parent.verticalCenter
            }

            CCLabel {
                id:                         scors
                font.pointSize:             20
                font.bold:                  true                     //黑体
                anchors.verticalCenter:    parent.verticalCenter
            }
        }
        Row {
            anchors.horizontalCenter:   parent.horizontalCenter
            CCLabel {
                font.pointSize:             20
                font.bold:                  true                     //黑体
                text:                       qsTr("Current Best:")
                anchors.verticalCenter:    parent.verticalCenter
            }
            CCLabel {
                id:                         best
                font.pointSize:             20
                font.bold:                  true                     //黑体
                anchors.verticalCenter:     parent.verticalCenter
            }
        }
        CCHoverHorzButton {
            id:                         gameoverImage
            text:                       qsTr("Restart")
            imageSource:                "/images/Restart.svg"
            anchors.horizontalCenter:   parent.horizontalCenter
            fontPointSize:              20
            onClicked:                  gameStart()
        }
    }

    ///3. 游戏结束界面, 加入弹簧动画
    SpringAnimation {
        id:         gameoverAnimation
        target:     gameoverColumn
        property:   "y";
        from:       -gameoverColumn.y
        to:         gameoverColumn.y
        spring:     2;
        damping:    0.7;
        duration:   1000;
        onStarted: {
            viewSwitch = gameOverView
        }
    }
}



/*-------------------------------------第二个版本 v0.2  -----------------------------------
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("疯狂算术")
    color:  "#84C1FF"

    property int  viewSwitch:       gameStartView

    readonly property int gameStartView:        1
    readonly property int gameContentView:      2
    readonly property int gameOverView:         3

    property int  currentScore:     0
    property int  bestScore:        0

    function gameStart() {
        viewSwitch = gameContentView
        currentScore = 0    //分数清零
        gameNext();
    }

    function gameNext() {
        timerText.restart()
        mathText.text = MathProblem.nextMath();
    }

    function gameOver() {
        scors.text = currentScore

        bestScore = Math.max(bestScore, currentScore)
        best.text = bestScore

        viewSwitch = gameOverView
        timerText.timerOver()
    }

    ///1. 游戏开始界面
    Button {
        id:                startBtn
        anchors.centerIn:  parent
        text:              "开始"
        visible:          viewSwitch === gameStartView
        onClicked:        gameStart()
    }

    ///2. 游戏中界面
    function checkAnswer(b) {
        if(b === MathProblem.isRight) {
            //回答正确
            currentScore = currentScore + 10 + timerText.seconds*5
            gameNext()
        }
        else {
            gameOver()
        }
    }
    Column {
        id:                         content
        visible:                    viewSwitch === gameContentView
        anchors.centerIn:           parent
        spacing:                    40

        Text {
            id:                     timerText;
            color:                  "white"
            font.pointSize:         28
            font.bold:              true
            text :                  seconds
            anchors.horizontalCenter: parent.horizontalCenter

            property int seconds: 4

            Timer {
                id: timer;
                interval: 1000;
                repeat: true;
                onTriggered:  {
                    timerText.seconds --
                    if(timerText.seconds === 0) {
                        gameOver()
                    }
                }
            }

            function timerOver() {
                seconds = 4
                timer.stop()
            }

            function restart() {
                seconds = 4
                timer.start()
            }
        }


        Text {
            id:                     mathText;
            color:                  "white"
            font.pointSize:         28
            font.bold:              true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing:                10
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "√"
                onClicked:      checkAnswer(true)
            }

            Button {
                text: "X"
                onClicked:      checkAnswer(false)
            }
        }

    }

    ///3. 游戏结束界面
    Column {
        id:                         gameoverColumn
        visible:                    viewSwitch === gameOverView
        anchors.centerIn:           parent
        spacing:                    20
        Text {
            id:                         gameoverText
            font.pointSize:             28
            font.bold:                  true                     //黑体
            text:                       "游戏结束!"
            anchors.horizontalCenter:   parent.horizontalCenter
        }
        Row {
            anchors.horizontalCenter:   parent.horizontalCenter

            Text {
                font.pointSize:             20
                font.bold:                  true                     //黑体
                text:                       "得分:"
                anchors.verticalCenter:    parent.verticalCenter
            }

            Text {
                id:                         scors
                font.pointSize:             20
                font.bold:                  true                     //黑体
                anchors.verticalCenter:    parent.verticalCenter
            }
        }
        Row {
            anchors.horizontalCenter:   parent.horizontalCenter
            Text {
                font.pointSize:             20
                font.bold:                  true                     //黑体
                text:                       "最高:"
                anchors.verticalCenter:    parent.verticalCenter
            }
            Text {
                id:                         best
                font.pointSize:             20
                font.bold:                  true                     //黑体
                anchors.verticalCenter:     parent.verticalCenter
            }
        }
        Image {
            id:                         gameoverImage
            source:                     "/images/Restart.svg"
            width:                      gameoverText.width * 0.5
            height:                     width
            fillMode :                  Image.PreserveAspectFit
            anchors.horizontalCenter:   parent.horizontalCenter
            MouseArea {
                anchors.fill:           parent
                onClicked:              gameStart()
            }
        }
    }
}
*/


/*-------------------------------------第一个版本 v0.1 -----------------------------------
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

///--1. 用最简单的UI, 先实现最核心的功能
Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("疯狂算术")
    color:  "#84C1FF"

    Button {
        id:                startBtn
        anchors.centerIn:  parent
        text: "开始"
        onClicked:        {
            startBtn.visible = false
            columnRoot.visible = true
            mathText.text = MathProblem.nextMath();
        }
    }

    Column {
        id:                         columnRoot
        visible:                    false
        anchors.top:                parent.top
        anchors.topMargin:          parent.width*0.1
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    20

        Text {
            id:                     mathText;
            color:                  "white"
            font.pointSize:         28
            font.bold:              true                     //黑体
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing:                10
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "√"
                onClicked:
                    mathText.text = MathProblem.nextMath();
            }

            Button {
                text: "X"
            }
        }
    }
}
*/

