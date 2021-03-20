import QtQuick 2.7
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0

Item {
    id:                             _leftMenu
    visible:                        true
    height:                         leftMunu.height;

    property alias color:           leftMunu.color
    property alias listViewIndex:   leftListView.currentIndex;
    property alias listModel:       leftListView.model

    property bool bMenuShown:       false
    property real listItemHeight:   30

    signal listIndex(int idx);

    Component.onCompleted: {
        listIndex(0)
    }

    Rectangle {
        id:                                 leftMunu
        height:                             rectHeader.height + leftItem.anchors.margins + leftItem.height
        width:                              parent.width
        ///--header
        Rectangle {
            id:                             rectHeader
            height:                         35
            width:                          parent.width
            color:                          "#5D478B"  //紫色
            Row {
                id:                         _rowHeader
                height:                     parent.height * 0.6
                width:                      parent.width
                anchors.centerIn:           parent;
                spacing:                    6

                Image {
                   id:                      innerImageHeader
                   height:                  parent.height
                   width:                   menuWidthShort    //_rootPlanView.fullMenuShow ? parent.width *1/3 : parent.width
                   smooth:                  true
                   mipmap:                  true
                   source:                  "/images/menu.png"
                   fillMode:                Image.PreserveAspectFit
                   antialiasing:            true
                }
                Label {
                   id:                      innerTextHeader
                   text:                    qsTr("目  录")
                   color:                   "white"
                   font.pointSize:          parent.height * 0.6
                   font.bold:               true
                   anchors.verticalCenter:  parent.verticalCenter
                   visible:                 root.fullMenuShow ? true : false
                }
            }

            Image {
                id:                         dottedlineHeader
                anchors.top:                _rowHeader.bottom;
                anchors.topMargin:          6
                fillMode:                   Image.Stretch
                source:                     "/images/line.png"
                sourceSize.height:          parent.height * 0.1;
                sourceSize.width:           parent.width;
                visible:                    root.fullMenuShow ? true : false
            }
        }
        ///--list view
        Item {
            id:                 leftItem
            height:             listItemHeight * leftListView.count
            width:              parent.width
            anchors.top:        rectHeader.bottom
            ListView{
                id:             leftListView
                anchors.fill:   parent
                delegate:       listDelegate
            }
        }

    }

    Component{
        id: listDelegate

        Rectangle{
            id: listItem
            property bool checked: false
            color:                          _leftMenu.color
            width:                          parent.width
            height:                         listItemHeight

            Connections{
                target:                     _leftMenu
                onListIndex:                listItem.checked = (idx===index);
            }
            Row {
                id:                         _row
                anchors.centerIn:           parent
                height:                     parent.height * 0.6
                width:                      parent.width
                spacing:                    6

                ColoredImage {
                    id:                     innerImage
                    width:                  menuWidthShort
                    height:                 parent.height
                    source:                 modelData.iconSource
                    color:                  listItem.checked?  "yellow" : "white"
                }
                Text {
                   id:                      innerText
                   text:                    modelData.name
                   color:                   listItem.checked?  "yellow" : "white"  //"#5DB6EA"
                   font.family:             "Microsoft Yahei" //友情提醒：商业用途会收费的
                   font.pointSize:          15
                   anchors.verticalCenter:  parent.verticalCenter
                   visible:                 root.fullMenuShow ? true : false
                }
            }
            Image {
                id:                         dottedline
                anchors.top:                _row.bottom;
                anchors.topMargin:          4
                fillMode:                   Image.Stretch
                source:                     "/images/line.png"
                sourceSize.height:          parent.height * 0.05;
                sourceSize.width:           parent.width;
                visible:                    root.fullMenuShow ? true : false
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    root.fullMenuShow = true
                    color = "green"
                }
                onExited: {
                    root.fullMenuShow = false
                    color  = _leftMenu.color
                }
                onClicked: {
                    listIndex(index)
                }
            }
        }
    }
}

