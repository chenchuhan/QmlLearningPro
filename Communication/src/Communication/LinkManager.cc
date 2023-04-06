/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include <QList>
//#include <QApplication>
#include <QDebug>
//#include <QSignalSpy>

#include <memory>

#include "LinkManager.h"
//#include "QGCApplication.h"
#include "UDPLink.h"
#include "TCPLink.h"
#include <QQmlApplicationEngine>

const char* LinkManager::_defaultUDPLinkName =       "UDP Link (AutoConnect)";
const char* LinkManager::_mavlinkForwardingLinkName =       "MAVLink Forwarding Link";

const int LinkManager::_autoconnectUpdateTimerMSecs =   1000;
#ifdef Q_OS_WIN
// Have to manually let the bootloader go by on Windows to get a working connect
const int LinkManager::_autoconnectConnectDelayMSecs =  6000;
#else
const int LinkManager::_autoconnectConnectDelayMSecs =  1000;
#endif

LinkManager::LinkManager()
{
//    qmlRegisterUncreatableType<LinkManager>         ("QGroundControl", 1, 0, "LinkManager",         "Reference only");
    qmlRegisterUncreatableType<LinkConfiguration>   ("Comm", 1, 0, "LinkConfiguration",   "Reference only");
    qmlRegisterUncreatableType<LinkInterface>       ("QGroundControl", 1, 0, "LinkInterface",       "Reference only");
}

LinkManager::~LinkManager()
{
}

void LinkManager::init(void)
{

    ///获取setting 中的自动连接
//    _autoConnectSettings = toolbox->settingsManager()->autoConnectSettings();

    connect(&_portListTimer, &QTimer::timeout, this, &LinkManager::_updateAutoConnectLinks);
    _portListTimer.start(_autoconnectUpdateTimerMSecs); // timeout must be long enough to get past bootloader on second pass
}

// This should only be used by Qml code
// connect
void LinkManager::createConnectedLink(LinkConfiguration* config)
{
    for(int i = 0; i < _rgLinkConfigs.count(); i++) {
        SharedLinkConfigurationPtr& sharedConfig = _rgLinkConfigs[i];
        if (sharedConfig.get() == config)
            createConnectedLink(sharedConfig);
    }
}

///--创建 link
bool LinkManager::createConnectedLink(SharedLinkConfigurationPtr& config)
{
    SharedLinkInterfacePtr link = nullptr;

    switch(config->type()) {
    case LinkConfiguration::TypeUdp:
        link = std::make_shared<UDPLink>(config);
        break;
    case LinkConfiguration::TypeTcp:
        link = std::make_shared<TCPLink>(config);
        break;
#ifdef QGC_ENABLE_BLUETOOTH
    case LinkConfiguration::TypeBluetooth:
        link = std::make_shared<BluetoothLink>(config);
        break;
#endif
    case LinkConfiguration::TypeLast:
        break;
    }

    if (link) {
        if (false == link->_allocateMavlinkChannel() ) {
//            qCWarning(LinkManagerLog) << "Link failed to setup mavlink channels";
            return false;
        }

        _rgLinks.append(link);
        config->setLink(link);

        ///--最重要接口之一： 接收到数据通过信号槽连接到何处
        connect(link.get(), &LinkInterface::bytesReceived,       _customer,    &Customer::receiveBytes);
//        connect(link.get(), &LinkInterface::bytesSent,           _mavlinkProtocol,    &MAVLinkProtocol::logSentBytes);
        connect(link.get(), &LinkInterface::disconnected,        this,                &LinkManager::_linkDisconnected);

//        _mavlinkProtocol->resetMetadataForLink(link.get());
//        _mavlinkProtocol->setVersion(_mavlinkProtocol->getCurrentVersion());

        if (!link->_connect()) {
            return false;
        }

        return true;
    }

    return false;
}

SharedLinkInterfacePtr LinkManager::mavlinkForwardingLink()
{
    for (int i = 0; i < _rgLinks.count(); i++) {
        SharedLinkConfigurationPtr linkConfig = _rgLinks[i]->linkConfiguration();
        if (linkConfig->type() == LinkConfiguration::TypeUdp && linkConfig->name() == _mavlinkForwardingLinkName) {
            SharedLinkInterfacePtr& link = _rgLinks[i];
            return link;
        }
    }

    return nullptr;
}

void LinkManager::disconnectAll(void)
{
    QList<SharedLinkInterfacePtr> links = _rgLinks;

    for (const SharedLinkInterfacePtr& sharedLink: links) {
        sharedLink->disconnect();
    }
}

void LinkManager::_linkDisconnected(void)
{
    LinkInterface* link = qobject_cast<LinkInterface*>(sender());

    if (!link || !containsLink(link)) {
        return;
    }

//    disconnect(link, &LinkInterface::communicationError,  _app,                &QGCApplication::criticalMessageBoxOnMainThread);
//    disconnect(link, &LinkInterface::bytesReceived,       _mavlinkProtocol,    &MAVLinkProtocol::receiveBytes);
//    disconnect(link, &LinkInterface::bytesSent,           _mavlinkProtocol,    &MAVLinkProtocol::logSentBytes);
    disconnect(link, &LinkInterface::disconnected,        this,                &LinkManager::_linkDisconnected);

    link->_freeMavlinkChannel();
    for (int i=0; i<_rgLinks.count(); i++) {
        if (_rgLinks[i].get() == link) {
//            qCDebug(LinkManagerLog) << "LinkManager::_linkDisconnected" << _rgLinks[i]->linkConfiguration()->name() << _rgLinks[i].use_count();
            _rgLinks.removeAt(i);
            return;
        }
    }
}

SharedLinkInterfacePtr LinkManager::sharedLinkInterfacePointerForLink(LinkInterface* link, bool ignoreNull)
{
    for (int i=0; i<_rgLinks.count(); i++) {
        if (_rgLinks[i].get() == link) {
            return _rgLinks[i];
        }
    }

    if (!ignoreNull)
        qWarning() << "LinkManager::sharedLinkInterfaceForLink returning nullptr";
    return SharedLinkInterfacePtr(nullptr);
}

void LinkManager::saveLinkConfigurationList()
{
    QSettings settings;
    settings.remove(LinkConfiguration::settingsRoot());
    int trueCount = 0;
    for (int i = 0; i < _rgLinkConfigs.count(); i++) {
        SharedLinkConfigurationPtr linkConfig = _rgLinkConfigs[i];
        if (linkConfig) {
            if (!linkConfig->isDynamic()) {
                QString root = LinkConfiguration::settingsRoot();
                root += QString("/Link%1").arg(trueCount++);
                settings.setValue(root + "/name", linkConfig->name());
                settings.setValue(root + "/type", linkConfig->type());
                settings.setValue(root + "/auto", linkConfig->isAutoConnect());
                settings.setValue(root + "/high_latency", linkConfig->isHighLatency());
                // Have the instance save its own values
                linkConfig->saveSettings(settings, root);
            }
        } else {
            qWarning() << "Internal error for link configuration in LinkManager";
        }
    }
    QString root(LinkConfiguration::settingsRoot());
    settings.setValue(root + "/count", trueCount);
}

void LinkManager::loadLinkConfigurationList()
{
    QSettings settings;
    // Is the group even there?
    if(settings.contains(LinkConfiguration::settingsRoot() + "/count")) {
        // Find out how many configurations we have
        int count = settings.value(LinkConfiguration::settingsRoot() + "/count").toInt();
        for(int i = 0; i < count; i++) {
            QString root(LinkConfiguration::settingsRoot());
            root += QString("/Link%1").arg(i);
            if(settings.contains(root + "/type")) {
                LinkConfiguration::LinkType type = static_cast<LinkConfiguration::LinkType>(settings.value(root + "/type").toInt());
                if(type < LinkConfiguration::TypeLast) {
                    if(settings.contains(root + "/name")) {
                        QString name = settings.value(root + "/name").toString();
                        if(!name.isEmpty()) {
                            LinkConfiguration* link = nullptr;
                            bool autoConnect = settings.value(root + "/auto").toBool();
                            bool highLatency = settings.value(root + "/high_latency").toBool();

                            switch(type) {
                            case LinkConfiguration::TypeUdp:
                                link = new UDPConfiguration(name);
                                break;
                            case LinkConfiguration::TypeTcp:
                                link = new TCPConfiguration(name);
                                break;
#ifdef QGC_ENABLE_BLUETOOTH
                            case LinkConfiguration::TypeBluetooth:
                                link = new BluetoothConfiguration(name);
                                break;
#endif
                            case LinkConfiguration::TypeLast:
                                break;
                            }
                            if(link) {
                                //-- Have the instance load its own values
                                link->setAutoConnect(autoConnect);
                                link->setHighLatency(highLatency);
                                link->loadSettings(settings, root);
                                addConfiguration(link);
                            }
                        } else {
                            qWarning() << "Link Configuration" << root << "has an empty name." ;
                        }
                    } else {
                        qWarning() << "Link Configuration" << root << "has no name." ;
                    }
                } else {
                    qWarning() << "Link Configuration" << root << "an invalid type: " << type;
                }
            } else {
                qWarning() << "Link Configuration" << root << "has no type." ;
            }
        }
    }
}

void LinkManager::_addUDPAutoConnectLink(void)
{
//    if (_autoConnectSettings->autoConnectUDP()->rawValue().toBool()) {
    if(1) {
        bool foundUDP = false;

        for (int i = 0; i < _rgLinks.count(); i++) {
            SharedLinkConfigurationPtr linkConfig = _rgLinks[i]->linkConfiguration();
            if (linkConfig->type() == LinkConfiguration::TypeUdp && linkConfig->name() == _defaultUDPLinkName) {
                foundUDP = true;
                break;
            }
        }

        if (!foundUDP) {
//            qCDebug(LinkManagerLog) << "New auto-connect UDP port added";
            //-- Default UDPConfiguration is set up for autoconnect
            UDPConfiguration* udpConfig = new UDPConfiguration(_defaultUDPLinkName);
            udpConfig->setDynamic(true);
            SharedLinkConfigurationPtr config = addConfiguration(udpConfig);
            createConnectedLink(config);
        }
    }
}



void LinkManager::_updateAutoConnectLinks(void)
{
    _addUDPAutoConnectLink();
}

void LinkManager::shutdown(void)
{
    disconnectAll();
}

QStringList LinkManager::linkTypeStrings(void) const
{
    //-- Must follow same order as enum LinkType in LinkConfiguration.h
    static QStringList list;
    if(!list.size())
    {
        list += tr("UDP");
        list += tr("TCP");
        if (list.size() != static_cast<int>(LinkConfiguration::TypeLast)) {
            qWarning() << "Internal error";
        }
    }
    return list;
}

QStringList LinkManager::serialPortStrings(void)
{
//    if(!_commPortDisplayList.size())
//    {
//        _updateSerialPorts();
//    }
    return _commPortDisplayList;
}

QStringList LinkManager::serialPorts(void)
{
//    if(!_commPortList.size())
//    {
//        _updateSerialPorts();
//    }
    return _commPortList;
}

bool LinkManager::endConfigurationEditing(LinkConfiguration* config, LinkConfiguration* editedConfig)
{
    if (config && editedConfig) {
        _fixUnnamed(editedConfig);
        config->copyFrom(editedConfig);
        saveLinkConfigurationList();
        emit config->nameChanged(config->name());
        // Discard temporary duplicate
        delete editedConfig;
    } else {
        qWarning() << "Internal error";
    }
    return true;
}

//qml add 的时候调用过
bool LinkManager::endCreateConfiguration(LinkConfiguration* config)
{
    if (config) {
        _fixUnnamed(config);
        addConfiguration(config);
        saveLinkConfigurationList();
    } else {
        qWarning() << "Internal error";
    }
    return true;
}

LinkConfiguration* LinkManager::createConfiguration(int type, const QString& name)
{
    return LinkConfiguration::createSettings(type, name);
}

LinkConfiguration* LinkManager::startConfigurationEditing(LinkConfiguration* config)
{
    if (config) {
        return LinkConfiguration::duplicateSettings(config);
    } else {
        qWarning() << "Internal error";
        return nullptr;
    }
}

void LinkManager::_fixUnnamed(LinkConfiguration* config)
{
    if (config) {
        //-- Check for "Unnamed"
        if (config->name() == "Unnamed") {
            switch(config->type()) {
            case LinkConfiguration::TypeUdp:
                config->setName(
                            QString("UDP Link on Port %1").arg(dynamic_cast<UDPConfiguration*>(config)->localPort()));
                break;
            case LinkConfiguration::TypeTcp: {
                TCPConfiguration* tconfig = dynamic_cast<TCPConfiguration*>(config);
                if(tconfig) {
                    config->setName(
                                QString("TCP Link %1:%2").arg(tconfig->address().toString()).arg(static_cast<int>(tconfig->port())));
                }
            }
                break;
#ifdef QGC_ENABLE_BLUETOOTH
            case LinkConfiguration::TypeBluetooth: {
                BluetoothConfiguration* tconfig = dynamic_cast<BluetoothConfiguration*>(config);
                if(tconfig) {
                    config->setName(QString("%1 (Bluetooth Device)").arg(tconfig->device().name));
                }
            }
                break;
#endif
            case LinkConfiguration::TypeLast:
                break;
            }
        }
    } else {
        qWarning() << "Internal error";
    }
}

void LinkManager::removeConfiguration(LinkConfiguration* config)
{
    if (config) {
        LinkInterface* link = config->link();
        if (link) {
            link->disconnect();
        }

        _removeConfiguration(config);
        saveLinkConfigurationList();
    } else {
        qWarning() << "Internal error";
    }
}

void LinkManager::_removeConfiguration(LinkConfiguration* config)
{
    _qmlConfigurations.removeOne(config);
    for (int i=0; i<_rgLinkConfigs.count(); i++) {
        if (_rgLinkConfigs[i].get() == config) {
            _rgLinkConfigs.removeAt(i);
            return;
        }
    }
    qWarning() << "LinkManager::_removeConfiguration called with unknown config";
}

bool LinkManager::containsLink(LinkInterface* link)
{
    for (int i=0; i<_rgLinks.count(); i++) {
        if (_rgLinks[i].get() == link) {
            return true;
        }
    }
    return false;
}

SharedLinkConfigurationPtr LinkManager::addConfiguration(LinkConfiguration* config)
{
    _qmlConfigurations.append(config);
    _rgLinkConfigs.append(SharedLinkConfigurationPtr(config));
    return _rgLinkConfigs.last();
}

void LinkManager::startAutoConnectedLinks(void)
{
    SharedLinkConfigurationPtr conf;
    for(int i = 0; i < _rgLinkConfigs.count(); i++) {
        conf = _rgLinkConfigs[i];
        if (conf->isAutoConnect())
            createConnectedLink(conf);
    }
}
