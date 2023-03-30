/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "LinkConfiguration.h"
#include "UDPLink.h"
#include "TCPLink.h"
#ifdef QGC_ENABLE_BLUETOOTH
#include "BluetoothLink.h"
#endif

#define LINK_SETTING_ROOT "LinkConfigurations"

LinkConfiguration::LinkConfiguration(const QString& name)
    : _name         (name)
    , _dynamic      (false)
    , _autoConnect  (false)
    , _highLatency  (false)
{
    _name = name;
    if (_name.isEmpty()) {
        qWarning() << "Internal error";
    }
}

LinkConfiguration::LinkConfiguration(LinkConfiguration* copy)
{
    _link       = copy->_link;
    _name       = copy->name();
    _dynamic    = copy->isDynamic();
    _autoConnect= copy->isAutoConnect();
    _highLatency= copy->isHighLatency();
    Q_ASSERT(!_name.isEmpty());
}

void LinkConfiguration::copyFrom(LinkConfiguration* source)
{
    Q_ASSERT(source != nullptr);
    _link       = source->_link;
    _name       = source->name();
    _dynamic    = source->isDynamic();
    _autoConnect= source->isAutoConnect();
    _highLatency= source->isHighLatency();
}

/*!
  Where the settings are saved
  @return The root path of the setting.
*/
const QString LinkConfiguration::settingsRoot()
{
    return QString(LINK_SETTING_ROOT);
}

/*!
  Configuration Factory
  @return A new instance of the given type
*/
LinkConfiguration* LinkConfiguration::createSettings(int type, const QString& name)
{
    LinkConfiguration* config = nullptr;
    switch(type) {
        case LinkConfiguration::TypeUdp:
            config = new UDPConfiguration(name);
            break;
        case LinkConfiguration::TypeTcp:
            config = new TCPConfiguration(name);
            break;
#ifdef QGC_ENABLE_BLUETOOTH
    case LinkConfiguration::TypeBluetooth:
        config = new BluetoothConfiguration(name);
        break;
#endif
    }
    return config;
}

/*!
  Duplicate link settings
  @return A new copy of the given settings instance
*/
LinkConfiguration* LinkConfiguration::duplicateSettings(LinkConfiguration* source)
{
    LinkConfiguration* dupe = nullptr;
    switch(source->type()) {
        case TypeUdp:
            dupe = new UDPConfiguration(qobject_cast<UDPConfiguration*>(source));
            break;
        case TypeTcp:
            dupe = new TCPConfiguration(qobject_cast<TCPConfiguration*>(source));
            break;
#ifdef QGC_ENABLE_BLUETOOTH
        case TypeBluetooth:
            dupe = new BluetoothConfiguration(qobject_cast<BluetoothConfiguration*>(source));
            break;
#endif

        case TypeLast:
            break;
    }
    return dupe;
}

void LinkConfiguration::setName(const QString name)
{
    _name = name;
    emit nameChanged(name);
}

void LinkConfiguration::setLink(SharedLinkInterfacePtr link)
{
    _link = link;
    emit linkChanged();
}
