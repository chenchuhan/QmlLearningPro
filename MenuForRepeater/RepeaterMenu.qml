import QtQuick.Layouts  1.2
import QtPositioning    5.2


import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.2

Item {
    id:                 menu
    visible:            true

    property real       maxHeight           ///< Maximum height for control, determines whether text is hidden to make control shorter
    property real       maxWidth
    property alias      listMode:            _repeater.model

    signal getListIndex(int idx);
    signal pageSig(int idx);

    Column {         //改为Row RowLoyout等都行
        id:                             rowItem
        anchors.margins:                4
        anchors.verticalCenter:         parent.verticalCenter
        anchors.left:                   parent.left
        height:                         parent.height * 0.6
        spacing:                        20
        Repeater {
            id:                         _repeater
            anchors.left:               parent.left
            delegate:                   listDelegate
        }
    }

    Component{
        id:                     listDelegate
        Rectangle {
            id:                 listItem
            property bool checked: false
            property bool oldChecked: false
            property int  clickCnt: 0

            width:                  innerImage.width
            height:                 innerImage.height
            color:                  Qt.rgba(0,0,0,0)  //无色
            opacity:                0.8               //透明度

            Connections{
                target:             menu
                onGetListIndex: {
                    //idx: click item ---- index: every item
                    if(idx === index ) {
                        //与前一次互斥事件, 大部分目录都是此逻辑
                        if(idx!==3) {
                            if(!listItem.oldChecked) {
                                listItem.checked = true
                                pageSig(idx)
                            }
                            else {
                                listItem.checked = false
                                pageSig(9)      //关闭此目录(回到主页)/工具
                            }
                        }
                        //可添加：连续点击事件 (工具栏中，需要此逻辑，如放大缩小)
                        else  {
                            listItem.checked = true
                            pageSig(idx)
                        }
                    }
                    //所有的子Item互斥
                    else {
                        listItem.checked = false
                    }
                    listItem.oldChecked = listItem.checked
                }
            }

            //水平线性渐变
            LinearGradient
            {
                id:                      innerImage
                width:                   maxWidth * 0.8  //_rootPlanView.fullMenuShow ? parent.width *1/3 : parent.width
                height:                  width
                anchors.margins:         (maxWidth - width ) / 2
                source: Image {
                    source:             modelData.iconSource
                }

                gradient: Gradient {
                    GradientStop {
                        position: 0.0;
                        color: listItem.checked ? "#ff8815" : "#0ea9ff"
                    }
                    GradientStop {
                        position: 1.0;
                        color: listItem.checked ? "#f6ff00" : "#2af8ff"
                    }
                }
                start:Qt.point(0,0)
                end:Qt.point(0,height)  //从上到下
            }

            Rectangle {
                id:                     innerRect
                visible:                false
                anchors.left:          listItem.right
                anchors.leftMargin:     10
                implicitHeight:         _label.height + _label.anchors.margins * 2
                implicitWidth:          _label.width + _label.anchors.margins * 2
                color:                  "green"//Qt.rgba(0,0,0,0)
                border.color:           "black"
                border.width:           2
                opacity:                0.8

                Text {
                    id:                     _label
                    anchors.right:          parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins:        3
                    text:                   modelData.name
                    font.family:            "Microsoft Yahei" //友情提醒：商业用途会收费的
                    font.pointSize:         15
                    color:                  "blue"
                }
            }

            MouseArea {
                anchors.fill: innerImage
                hoverEnabled: true

                onEntered: {
                    innerRect.visible = true
                }
                onExited: {
                    innerRect.visible = false

                }
                onClicked: {
                    getListIndex(index)
                }
            }
        }
    }
}
