import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2

import QmlControls      1.0
import Palette          1.0
import Comm             1.0

Rectangle {
    id:                             _linkRoot
    color:                          pal.window

    property color _windowColor:     "#66000000"
    property var _currentSelection: null
    property int _firstColumn:      100//ScreenTools.defaultWidth * 12
    property int _secondColumn:     200//ScreenTools.defaultWidth * 30

    Palette {
        id:                 pal
    }

    function openCommSettings(lconf) {
        settingLoader.linkConfig = lconf
        settingLoader.sourceComponent = commSettings
        settingLoader.visible = true
    }

    function closeCommSettings() {
        settingLoader.visible = false
        settingLoader.sourceComponent = null
    }

    Flickable{
        clip:               true
        width:              parent.width
        height:             parent.height - buttonRow.height
        contentHeight:      settingsColumn.height
        contentWidth:       _linkRoot.width
        flickableDirection: Flickable.VerticalFlick

        ///--已连接的列表
        Column {
            id:                 settingsColumn
            width:              _linkRoot.width
            anchors.margins:    _margin//ScreenTools.defaultWidth
            spacing:            _margin//ScreenTools.defaultHeight / 2
            Repeater {
                model:             LinkManager.linkConfigurations
                delegate: Button   /*QGCButton*/ {
                    anchors.horizontalCenter:   settingsColumn.horizontalCenter
                    width:                      _linkRoot.width * 0.5
                    text:                        object.name
//                    autoExclusive:              true
                    visible:                    !object.dynamic
                    onClicked: {
                        checked = true
                        _currentSelection = object
                    }
                }
            }
        }
    }
    ///--增删改查 可操作的 下方
    Row {
        id:                 buttonRow
        spacing:            ScreenTools.margin
        anchors.bottom:     parent.bottom
        anchors.margins:    ScreenTools.margin
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
            width:      40//ScreenTools.defaultWidth * 10
            text:       qsTr("Delete")
            enabled:    _currentSelection && !_currentSelection.dynamic
            onClicked: {
                if(_currentSelection)
                    deleteDialog.visible = true
            }
            MessageDialog {
                id:         deleteDialog
                visible:    false
                icon:       StandardIcon.Warning
                standardButtons: StandardButton.Yes | StandardButton.No
                title:      qsTr("Remove Link Configuration")
                text:       _currentSelection ? qsTr("Remove %1. Is this really what you want?").arg(_currentSelection.name) : ""
                onYes: {
                    if(_currentSelection)
                        LinkManager.removeConfiguration(_currentSelection)
                    deleteDialog.visible = false
                }
                onNo: {
                    deleteDialog.visible = false
                }
            }
        }
        Button {
            text:       qsTr("Edit")
            enabled:    _currentSelection && !_currentSelection.link
            onClicked: {
                _linkRoot.openCommSettings(_currentSelection)
            }
        }
        Button {
            text:       qsTr("Add")
            onClicked: {
                _linkRoot.openCommSettings(null)
            }
        }
        Button {
            text:       qsTr("Connect")
            enabled:    _currentSelection && !_currentSelection.link
            onClicked:  LinkManager.createConnectedLink(_currentSelection)
        }
        Button {
            text:       qsTr("Disconnect")
            enabled:    _currentSelection && _currentSelection.link
            onClicked:  _currentSelection.link.disconnect()  //调用例如，tcp中的断开，仅仅是断开，不是从列表中删除
        }
    }

    Loader {
        id:             settingLoader
        anchors.fill:   parent
        visible:        false
        property var linkConfig: null
        property var editConfig: null  //编辑的配置
    }

    //---------------------------------------------
    // Comm Settings
    Component {
        id: commSettings
        Rectangle {
            id:             settingsRect
            color:          _windowColor
            anchors.fill:   parent
            property real   _panelWidth:    width * 0.8
            Component.onCompleted: {
                // If editing, create copy for editing
                if(linkConfig) {
                    editConfig = LinkManager.startConfigurationEditing(linkConfig)
                } else {
                    // Create new link configuration
                    if(ScreenTools.isSerialAvailable) {
                        //LinkConfiguration.TypeSerial 枚举类型
                        editConfig = LinkManager.createConfiguration(LinkConfiguration.TypeSerial, "Unnamed")
                    } else {
                        ///--默认UDP连接
                        editConfig = LinkManager.createConfiguration(LinkConfiguration.TypeUdp,    "Unnamed")
                    }
                }
            }
            Component.onDestruction: {
                if(editConfig) {
                    LinkManager.cancelConfigurationEditing(editConfig)
                    editConfig = null
                }
            }

            //start_cch_20210803 突破口
            Column {
                id:                 settingsTitle
                spacing:            ScreenTools.defaultHeight * 0.5
                Label {
                    text:   linkConfig ? qsTr("Edit Link Configuration Settings") : qsTr("Create New Link Configuration")
                }
                Rectangle {
                    height: 1
                    width:  settingsRect.width
                    color:  pal.button
                }
            }

            Flickable {
                id:                 settingsFlick
                clip:               true
                anchors.top:        settingsTitle.bottom
                anchors.bottom:     commButtonRow.top
                width:              parent.width
                anchors.margins:    ScreenTools.defaultWidth
                contentHeight:      commSettingsColumn.height
                contentWidth:       _linkRoot.width
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior:     Flickable.StopAtBounds
                Column {
                    id:                 commSettingsColumn
                    width:              _linkRoot.width
                    anchors.margins:    ScreenTools.defaultWidth
                    spacing:            ScreenTools.defaultHeight * 0.5
                    //-----------------------------------------------------------------
                    //-- General
                    Item {
                        width:                      _panelWidth
                        height:                     generalLabel.height
                        anchors.margins:            ScreenTools.defaultWidth
                        anchors.horizontalCenter:   parent.horizontalCenter
                        Label {
                            id:                     generalLabel
                            text:                   qsTr("General")
                        }
                    }
                    Rectangle {
                        height:                     generalCol.height + (ScreenTools.defaultHeight * 2)
                        width:                      _panelWidth
                        color:                      "#88000000"//_windowColorShade
                        anchors.margins:            ScreenTools.defaultWidth
                        anchors.horizontalCenter:   parent.horizontalCenter
                        Column {
                            id:                     generalCol
                            anchors.centerIn:       parent
                            anchors.margins:        ScreenTools.defaultWidth
                            spacing:                ScreenTools.defaultHeight * 0.5
                            Row {
                                spacing:    ScreenTools.defaultWidth
                                QmlLabel {
                                    text:   qsTr("Name:")
                                    width:  _firstColumn
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                TextField {
                                    id:     nameField
                                    text:   editConfig ? editConfig.name : ""
                                    width:  _secondColumn
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            Row {
                                spacing:            ScreenTools.defaultWidth
                                QmlLabel {
                                    text:           qsTr("Type:")
                                    width:          _firstColumn
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                //-----------------------------------------------------
                                // When editing, you can't change the link type
                                QmlLabel {
                                    text:           linkConfig ? LinkManager.linkTypeStrings[linkConfig.linkType] : ""
                                    visible:        linkConfig != null
                                    width:          _secondColumn
                                    anchors.verticalCenter: parent.verticalCenter
                                    Component.onCompleted: {
                                        if(linkConfig != null) {
                                            linkSettingLoader.source  = linkConfig.settingsURL
                                            linkSettingLoader.visible = true
                                        }
                                    }
                                }
                                //-----------------------------------------------------
                                // When creating, select a link type
                                QmlComboBox {
                                    id:             linkTypeCombo
                                    width:          _secondColumn
                                    visible:        linkConfig == null
                                    model:          LinkManager.linkTypeStrings
                                    anchors.verticalCenter: parent.verticalCenter
                                    onActivated: {
                                        if (index != -1 && index !== editConfig.linkType) {
                                            // Destroy current panel
                                            linkSettingLoader.source = ""
                                            linkSettingLoader.visible = false
                                            // Save current name
                                            var name = nameField.text
                                            // Discard link configuration (old type)
                                            LinkManager.cancelConfigurationEditing(editConfig)
                                            // Create new link configuration
                                            editConfig = LinkManager.createConfiguration(index, name)
                                            // Load appropriate configuration panel
                                            linkSettingLoader.source  = editConfig.settingsURL
                                            linkSettingLoader.visible = true
                                        }
                                    }
                                    Component.onCompleted: {
                                        if(linkConfig == null) {
                                            linkTypeCombo.currentIndex = 0
                                            linkSettingLoader.source   = editConfig.settingsURL
                                            linkSettingLoader.visible  = true
                                        }
                                    }
                                }
                            }
                            Item {
                                height: ScreenTools.defaultHeight * 0.5
                                width:  parent.width
                            }
                            //-- Auto Connect on Start
//                            CheckBox {
//                                text:               qsTr("Automatically Connect on Start")
//                                checked:            false
//                                onCheckedChanged: {
//                                    if(editConfig) {
//                                        editConfig.autoConnect = checked
//                                    }
//                                }
//                                Component.onCompleted: {
//                                    if(editConfig)
//                                        checked = editConfig.autoConnect
//                                }
//                            }
//                            QGCCheckBox {
//                                text:               qsTr("High Latency")
//                                checked:            false
//                                onCheckedChanged: {
//                                    if(editConfig) {
//                                        editConfig.highLatency = checked
//                                    }
//                                }
//                                Component.onCompleted: {
//                                    if(editConfig)
//                                        checked = editConfig.highLatency
//                                }
//                            }
                        }
                    }
                    Item {
                        height: ScreenTools.defaultHeight
                        width:  parent.width
                    }
                    //-----------------------------------------------------------------
                    //-- Link Specific Settings
                    Item {
                        width:                      _panelWidth
                        height:                     linkLabel.height
                        anchors.margins:            ScreenTools.defaultWidth
                        anchors.horizontalCenter:   parent.horizontalCenter
                        QmlLabel {
                            id:                     linkLabel
                            text:                   editConfig ? editConfig.settingsTitle : ""
                            visible:                linkSettingLoader.source != ""
                        }
                    }
                    Rectangle {
                        height:                     linkSettingLoader.height + (ScreenTools.defaultHeight * 2)
                        width:                      _panelWidth
                        color:                      _windowColor
                        anchors.margins:            ScreenTools.defaultWidth
                        anchors.horizontalCenter:   parent.horizontalCenter
                        Item {
                            height:                 linkSettingLoader.height
                            width:                  linkSettingLoader.width
                            anchors.centerIn:       parent
                            Loader {
                                id:                 linkSettingLoader
                                visible:            false
                                property var subEditConfig: editConfig
                            }
                        }
                    }
                }
            }

            ///--√
            Row {
                id:                 commButtonRow
                spacing:            ScreenTools.defaultWidth
                anchors.margins:    ScreenTools.defaultWidth
                anchors.bottom:     parent.bottom
                anchors.right:      parent.right
                Button {
                    width:      ScreenTools.defaultWidth * 10
                    text:       qsTr("OK")
                    enabled:    nameField.text !== ""
                    onClicked: {
                        // Save editting
                        linkSettingLoader.item.saveSettings()
                        editConfig.name = nameField.text
                        if(linkConfig) {
                            LinkManager.endConfigurationEditing(linkConfig, editConfig)
                        } else {
                            // If it was edited, it's no longer "dynamic"
                            editConfig.dynamic = false
                            LinkManager.endCreateConfiguration(editConfig)
                        }
                        linkSettingLoader.source = ""
                        editConfig = null
                        _linkRoot.closeCommSettings()
                    }
                }
                QmlButton1 {
                    width:      ScreenTools.defaultWidth * 10
                    text:       qsTr("Cancel")
                    onClicked: {
                        LinkManager.cancelConfigurationEditing(editConfig)
                        editConfig = null
                        _linkRoot.closeCommSettings()
                    }
                }
            }
        }
    }
}
