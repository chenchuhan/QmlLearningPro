/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2

import QmlControls      1.0
import Palette          1.0
import Comm             1.0

Column {
    id:                 _udpSetting
    spacing:            ScreenTools.margin
    anchors.margins:    ScreenTools.margin

    function saveSettings() {
        // No need
    }

    property string _currentHost: ""

    Row {
        spacing:    ScreenTools.margin
        Label {
            text:   qsTr("Listening Port:")
            width:  _firstColumn
            anchors.verticalCenter: parent.verticalCenter
        }
        TextField {
            id:     portField
            text:   subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeUdp ? subEditConfig.localPort.toString() : ""
            focus:  true
            width:  _firstColumn
            inputMethodHints:       Qt.ImhFormattedNumbersOnly
            anchors.verticalCenter: parent.verticalCenter
            onTextChanged: {
                if(subEditConfig) {
                    subEditConfig.localPort = parseInt(portField.text)
                }
            }
        }
    }
    Item {
        height: ScreenTools.defaultFontPixelHeight / 2
        width:  parent.width
    }
    Label {
        text:   qsTr("Target Hosts:")
    }
    Item {
        width:  hostRow.width
        height: hostRow.height
        Row {
            id:      hostRow
            spacing: ScreenTools.margin
            Item {
                height: 1
                width:  _firstColumn
            }
            Column {
                id:         hostColumn
                spacing:    ScreenTools.margin
                Rectangle {
                    height:  1
                    width:   _secondColumn
                    color:   pal.button
                    visible: subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeUdp && subEditConfig.hostList.length > 0
                }
                Repeater {
                    model: subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeUdp ? subEditConfig.hostList : ""
                    delegate:
                    Button {
                        text:               modelData
                        width:              _secondColumn
                        anchors.leftMargin: ScreenTools.margin * 2
//                        autoExclusive:      true
                        onClicked: {
                            checked = true
                            _udpSetting._currentHost = modelData
                        }
                    }
                }
                TextField {
                    id:         hostField
                    focus:      true
                    visible:    false
                    width:      ScreenTools.margin * 15//30  //start_cch_20220411
                    onEditingFinished: {
                        if(subEditConfig) {
                            if(hostField.text !== "") {
                                subEditConfig.addHost(hostField.text)
                                hostField.text = ""
                            }
                            hostField.visible = false
                        }
                    }
                    Keys.onReleased: {
                        if (event.key === Qt.Key_Escape) {
                            hostField.text = ""
                            hostField.visible = false
                        }
                    }
                }
                Rectangle {
                    height: 1
                    width:  _secondColumn
                    color:  pal.button
                }
                Item {
                    height: ScreenTools.defaultFontPixelHeight / 2
                    width:  parent.width
                }
                Item {
                    width:  _secondColumn
                    height: udpButtonRow.height
                    Row {
                        id:         udpButtonRow
                        spacing:    ScreenTools.margin
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            width:      ScreenTools.defaultWidth * 10
                            text:       qsTr("Add")
                            onClicked: {
                                if(hostField.visible && hostField.text !== "") {
                                    subEditConfig.addHost(hostField.text)
                                    hostField.text = ""
                                    hostField.visible = false
                                } else
                                    hostField.visible = true
                            }
                        }
                        Button {
                            width:      ScreenTools.defaultWidth * 10
                            enabled:    _udpSetting._currentHost && _udpSetting._currentHost !== ""
                            text:       qsTr("Remove")
                            onClicked: {
                                subEditConfig.removeHost(_udpSetting._currentHost)
                            }
                        }
                    }
                }
            }
        }
    }
}
