import QtQuick                  2.12
import QtQuick.Controls         2.12

import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.SGControls    1.0


Rectangle {

    color:          "black"//"#696969"
    border.color:   'black'//qgcPal.sgTheme
    border.width: 0
    //外部给定宽高和文字的宽高

    property bool isFirstOne: false
    property real fontPointsize: 11
    property var  firstText:    "已解保"
    property var  secondText:   "保险"
    property real opacityLow:   0.7

    //后续添加图片

    onIsFirstOneChanged: {
        if(isFirstOne)  {
            an1.running = true
            an1.start()
            an2.running = false
            an2.stop()
        }
        else {
            an1.running = false
            an1.stop()
            an2.running = true
            an2.start()
        }
    }

    SequentialAnimation {
        id:     an1
        loops:  Animation.Infinite
        PropertyAnimation {
            id:         an11
            target:     firstOne
            property:   "opacity"         //记得加引号
            from:   1
            to:     opacityLow + 0.1
//            loops:  Animation.Infinite   //不能加
            duration: 800//600//1000//2000//1500
        }
        PropertyAnimation {
            id:         an12
            target:     firstOne
            property:   "opacity"
            from:   opacityLow
            to:     1
            duration: 800//600//1000//2000//1500
        }
    }

    SequentialAnimation {
        id:     an2
        running: true
        loops:  Animation.Infinite
        PropertyAnimation {
            id:         an21
            target:     secondOne
            property:   "opacity"         //记得加引号
            from:       1
            to:     opacityLow + 0.1
            duration: 800//600//1000//2000//1500
        }
        PropertyAnimation {
            id:         an22
            target:     secondOne
            property:   "opacity"
            from:       opacityLow
            to:         1
            duration:    800//600//1000//2000//1500
        }
    }

    Row {

        anchors.fill:       parent
        anchors.margins:    4

        spacing: 4

        Rectangle {
            id:     firstOne
            width: (parent.width - parent.spacing)/2
            height: parent.height
            radius:             2

            color:      isFirstOne ? qgcPal.sgButton/*qgcPal.sgTheme*/ : "#F5F5DC"//"#E6E6FA"//#F5DEB3"//"#FFFFE0"
            opacity:    isFirstOne ? 1.0 : opacityLow

            SGLabel {
                anchors.centerIn: parent
                text:           firstText

                font.pointSize: isFirstOne ? 11 : 10
                color:          isFirstOne ? "black" : "black"
                font.bold:      isFirstOne ? true : false
            }
        }

        Rectangle {
            id:         secondOne
            width:      firstOne.width
            height:     parent.height
            radius:     2

            color:      !isFirstOne ? qgcPal.sgButton/*qgcPal.sgTheme*/ : "#F5F5DC"//"#E6E6FA"//"#F5DEB3"//"#FFFFE0"
            opacity:    !isFirstOne ? 1.0 : opacityLow

            SGLabel {
                anchors.centerIn: parent
                text:           secondText

                font.pointSize: !isFirstOne ? 11 : 10
                color:          !isFirstOne ? "black" : "black"
                font.bold:      !isFirstOne ? true : false
            }
        }
        //"#FFFFF0"//"#E6E6FA"//"#F5DEB3"//"#FFFFE0"
    }
}

/* [素材]
//    PropertyAnimation {
//        id:     an
//        target: firstOne
//        property:   "opacity"
//        from:   1
//        to:     0.2
//        loops:  Animation.Infinite
//        duration: 2000
//        running: true
//    }
*/
