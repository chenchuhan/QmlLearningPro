import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4

Window {
    id:     rootWindow
    visible: true
    width: 700
    height: 430
    title: qsTr("Popup Test!!!")

    Test {
        anchors.fill:   parent
    }

    ///-------------------------居中弹窗-------------------------\\\
    function showPopupCenter(raiseItem) {
        popupCenter.raiseItem = raiseItem
        popupCenter.open()
    }

    Popup {
        id:             popupCenter
        modal:          true            //模态， 为 true后弹出窗口会叠加一个独特的背景调光效果
        focus:          true            //焦点,  当弹出窗口实际接收到焦点时，activeFocus将为真
        padding:        0

        closePolicy:    Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property var    raiseItem:          null

        background: Rectangle {
//            width:      loaderCenter.width
//            height:     loaderCenter.height
            color:      Qt.rgba(0,0,0,0)   //背景为无色
        }

        Loader {
            id:             loaderCenter
            onLoaded: {
                popupCenter.x = (rootWindow.width - loaderCenter.width) * 0.5
                popupCenter.y = (rootWindow.height - loaderCenter.height) * 0.5
            }
        }
        onOpened: {
            loaderCenter.sourceComponent = popupCenter.raiseItem
        }
        onClosed: {
            loaderCenter.sourceComponent = null
            popupCenter.raiseItem = null
        }
    }

    ///----------------------正下方弹窗-------------------------\\\
    function showPopupBottom(raiseItem, btnItem) {
        popupBottom.raiseItem = raiseItem
        popupBottom.btnItem = btnItem
        popupBottom.open()
    }

    Popup {
        id:             popupBottom
        modal:          true        //模态， 为 true后弹出窗口会叠加一个独特的背景调光效果
        focus:          true        //焦点,  当弹出窗口实际接收到焦点时，activeFocus将为真
        closePolicy:    Popup.CloseOnEscape | Popup.CloseOnPressOutside
        padding:        0           //很重要
        property var    raiseItem:          null  //要显示的组件
        property var    btnItem:       null  //提供位置的组件
        background: Rectangle {
            color:  Qt.rgba(0,0,0,0)    //背景为无色
        }
        Loader {
            id:             loaderBottom
            onLoaded: {
                var item =  rootWindow.contentItem.mapFromItem(popupBottom.btnItem, 0 ,0)
                popupBottom.x = item.x
                //考虑右边边界问题
                if(popupBottom.x + loaderBottom.width > rootWindow.width) {
                    popupBottom.x = rootWindow.width - loaderBottom.width
                }
                //考虑左边边界问题
                popupBottom.y = item.y + popupBottom.btnItem.height
                if(popupBottom.y + loaderBottom.height > rootWindow.height) {
                    popupBottom.y = rootWindow.height - loaderBottom.height
                }
            }
        }
        onOpened: {
            loaderBottom.sourceComponent = popupBottom.raiseItem
        }
        onClosed: {
            loaderBottom.sourceComponent = null
            popupBottom.raiseItem = null
        }
    }
}
