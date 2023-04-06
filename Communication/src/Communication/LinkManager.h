/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QList>
#include <QMultiMap>
#include <QMutex>

#include <limits>

#include "LinkConfiguration.h"
#include "LinkInterface.h"
//#include "QGCToolbox.h"
//#include "MAVLinkProtocol.h"
#if !defined(__mobile__)
#include "UdpIODevice.h"
#endif
#include "QmlObjectListModel.h"

//Q_DECLARE_LOGGING_CATEGORY(LinkManagerLog)
//Q_DECLARE_LOGGING_CATEGORY(LinkManagerVerboseLog)

class QGCApplication;
class UDPConfiguration;
class AutoConnectSettings;
class LogReplayLink;

class Customer;

/// @brief Manage communication links
///
/// The Link Manager organizes the physical Links. It can manage arbitrary
/// links and takes care of connecting them as well assigning the correct
/// protocol instance to transport the link data into the application.

class LinkManager : public QObject {
    Q_OBJECT

public:
    LinkManager();
    ~LinkManager();

    Q_PROPERTY(QmlObjectListModel*  linkConfigurations      READ _qmlLinkConfigurations CONSTANT)
    Q_PROPERTY(QStringList          linkTypeStrings         READ linkTypeStrings        CONSTANT)

    /// Create/Edit Link Configuration
    Q_INVOKABLE LinkConfiguration*  createConfiguration         (int type, const QString& name);
    Q_INVOKABLE LinkConfiguration*  startConfigurationEditing   (LinkConfiguration* config);
    Q_INVOKABLE void                cancelConfigurationEditing  (LinkConfiguration* config) { delete config; }
    Q_INVOKABLE bool                endConfigurationEditing     (LinkConfiguration* config, LinkConfiguration* editedConfig);
    Q_INVOKABLE bool                endCreateConfiguration      (LinkConfiguration* config);
    Q_INVOKABLE void                removeConfiguration         (LinkConfiguration* config);

    // Called to signal app shutdown. Disconnects all links while turning off auto-connect.
    Q_INVOKABLE void shutdown(void);

    // Property accessors


    QList<SharedLinkInterfacePtr>   links               (void) { return _rgLinks; }
    QStringList                     linkTypeStrings     (void) const;
    QStringList                     serialBaudRates     (void);
    QStringList                     serialPortStrings   (void);
    QStringList                     serialPorts         (void);

    void loadLinkConfigurationList();
    void saveLinkConfigurationList();

    /// Creates, connects (and adds) a link  based on the given configuration instance.
    bool createConnectedLink(SharedLinkConfigurationPtr& config);

    // This should only be used by Qml code
    Q_INVOKABLE void createConnectedLink(LinkConfiguration* config);

    /// Returns pointer to the mavlink forwarding link, or nullptr if it does not exist
    SharedLinkInterfacePtr mavlinkForwardingLink();

    void disconnectAll(void);

    static constexpr uint8_t invalidMavlinkChannel(void) { return std::numeric_limits<uint8_t>::max(); }

    /// Allocates a mavlink channel for use
    /// @return Mavlink channel index, invalidMavlinkChannel() for no channels available

    /// If you are going to hold a reference to a LinkInterface* in your object you must reference count it
    /// by using this method to get access to the shared pointer.
    SharedLinkInterfacePtr sharedLinkInterfacePointerForLink(LinkInterface* link, bool ignoreNull=false);

    bool containsLink(LinkInterface* link);

    SharedLinkConfigurationPtr addConfiguration(LinkConfiguration* config);

    void startAutoConnectedLinks(void);

    static const char*  settingsGroup;

    void init(void);


signals:
    void commPortStringsChanged();
    void commPortsChanged();

private slots:
    void _linkDisconnected  (void);

private:
    QmlObjectListModel* _qmlLinkConfigurations      (void) { return &_qmlConfigurations; }
    bool                _connectionsSuspendedMsg    (void);
    void                _updateAutoConnectLinks     (void);
    void                _updateSerialPorts          (void);
    void                _fixUnnamed                 (LinkConfiguration* config);
    void                _removeConfiguration        (LinkConfiguration* config);
    void                _addUDPAutoConnectLink      (void);

    bool                                _configUpdateSuspended;                     ///< true: stop updating configuration list
    bool                                _connectionsSuspended;                      ///< true: all new connections should not be allowed
    QString                             _connectionsSuspendedReason;                ///< User visible reason for suspension
    QTimer                              _portListTimer;

    AutoConnectSettings*                _autoConnectSettings = nullptr;
//    MAVLinkProtocol*                    _mavlinkProtocol;
    =

    QList<SharedLinkInterfacePtr>       _rgLinks;
    QList<SharedLinkConfigurationPtr>   _rgLinkConfigs;
    QString                             _autoConnectRTKPort;
    QmlObjectListModel                  _qmlConfigurations;

    QMap<QString, int>                  _autoconnectPortWaitList;               ///< key: QGCSerialPortInfo::systemLocation, value: wait count
    QStringList                         _commPortList;
    QStringList                         _commPortDisplayList;

    static const char*  _defaultUDPLinkName;
    static const char*  _mavlinkForwardingLinkName;
    static const int    _autoconnectUpdateTimerMSecs;
    static const int    _autoconnectConnectDelayMSecs;

};

