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

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.SGControls              1.0

Column {
    id:                 _btSettings
    spacing:            ScreenTools.defaultFontPixelHeight * 0.5
    anchors.margins:    ScreenTools.defaultFontPixelWidth
    visible:            QGroundControl.linkManager.isBluetoothAvailable
    function saveSettings() {
        // No need
    }
    Row {
        spacing:    ScreenTools.defaultFontPixelWidth
        SGLabel {
            text:   qsTr("设备:")
            width:  _firstColumn
            _small:  true
        }
        SGLabel {
            id:     deviceField
            text:   subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeBluetooth ? subEditConfig.devName : ""
            _small:  true
        }
    }
    Row {
        visible:    !ScreenTools.isiOS
        spacing:    ScreenTools.defaultFontPixelWidth
        SGLabel {
            text:   qsTr("地址:")
            width:  _firstColumn
            _small:  true
        }
        SGLabel {
            id:     addressField
            text:   subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeBluetooth ? subEditConfig.address : ""
            _small:  true
        }
    }
    Item {
        height: ScreenTools.defaultFontPixelHeight / 2
        width:  parent.width
    }
    SGLabel {
        text:   qsTr("蓝牙设备：")
        _small:  true
    }

    Item {
        width:  hostRow.width
        height: hostRow.height
        Row {
            id:      hostRow
            spacing: ScreenTools.defaultFontPixelWidth
            Item {
                height: 1
                width:  _firstColumn
            }
            Column {
                id:         hostColumn
                spacing:    ScreenTools.defaultFontPixelHeight / 2
                Rectangle {
                    height:  1
                    width:   _secondColumn
                    color:   qgcPal.button
                    visible: subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeBluetooth && subEditConfig.nameList.length > 0
                }
                Repeater {
                    model: subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeBluetooth ? subEditConfig.nameList : ""
                    delegate:
                    SGButton {
                        text:               modelData
                        width:              _secondColumn
                        anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
                        autoExclusive:      true
                        onClicked: {
                            checked = true
                            if(subEditConfig && modelData !== "")
                                subEditConfig.devName = modelData
                        }
                    }
                }
                Rectangle {
                    height: 1
                    width:  _secondColumn
                    color:  qgcPal.button
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
                        spacing:    ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        SGButton {
                            width:      ScreenTools.defaultFontPixelWidth * 10
                            text:       qsTr("扫描")
                            enabled:    subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeBluetooth && !subEditConfig.scanning
                            onClicked: {
                                if(subEditConfig)
                                    subEditConfig.startScan()
                            }
                        }
                        SGButton {
                            width:      ScreenTools.defaultFontPixelWidth * 10
                            text:       qsTr("停止")
                            enabled:    subEditConfig && subEditConfig.linkType === LinkConfiguration.TypeBluetooth && subEditConfig.scanning
                            onClicked: {
                                if(subEditConfig)
                                    subEditConfig.stopScan()
                            }
                        }
                    }
                }
            }
        }
    }
}

