/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "LinkInterface.h"
#include "LinkManager.h"

#include "qqmlengine.h"


// The LinkManager is only forward declared in the header, so the static_assert is here instead.
static_assert(LinkManager::invalidMavlinkChannel() == std::numeric_limits<uint8_t>::max(), "update LinkInterface::_mavlinkChannel");

LinkInterface::LinkInterface(SharedLinkConfigurationPtr& config, bool isPX4Flow)
    : QThread   (0)
    , _config   (config)
    , _isPX4Flow(isPX4Flow)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<LinkInterface*>("LinkInterface*");
}

LinkInterface::~LinkInterface()
{
    if (_vehicleReferenceCount != 0) {
//        qCWarning(LinkInterfaceLog) << "~LinkInterface still have vehicle references:" << _vehicleReferenceCount;
    }
    _config.reset();
}

uint8_t LinkInterface::mavlinkChannel(void) const
{
    if (!mavlinkChannelIsSet()) {
    }
    return _mavlinkChannel;
}

bool LinkInterface::mavlinkChannelIsSet(void) const
{
    return (LinkManager::invalidMavlinkChannel() != _mavlinkChannel);
}

bool LinkInterface::_allocateMavlinkChannel()
{
//    // should only be called by the LinkManager during setup
//    Q_ASSERT(!mavlinkChannelIsSet());
//    if (mavlinkChannelIsSet()) {
//        return true;
//    }

//    auto mgr = qgcApp()->toolbox()->linkManager();
//    _mavlinkChannel = mgr->allocateMavlinkChannel();
//    if (!mavlinkChannelIsSet()) {
//        return false;
//    }
    return true;
}

void LinkInterface::_freeMavlinkChannel()
{
//    if (LinkManager::invalidMavlinkChannel() == _mavlinkChannel) {
//        return;
//    }

//    auto mgr = qgcApp()->toolbox()->linkManager();
//    mgr->freeMavlinkChannel(_mavlinkChannel);
//    _mavlinkChannel = LinkManager::invalidMavlinkChannel();
}

void LinkInterface::writeBytesThreadSafe(const char *bytes, int length)
{
    QByteArray byteArray(bytes, length);
    _writeBytesMutex.lock();
    _writeBytes(byteArray);
    _writeBytesMutex.unlock();
}

void LinkInterface::addVehicleReference(void)
{
    _vehicleReferenceCount++;
}

void LinkInterface::removeVehicleReference(void)
{
    if (_vehicleReferenceCount != 0) {
        _vehicleReferenceCount--;
        if (_vehicleReferenceCount == 0) {
            disconnect();
        }
    } else {
//        qCWarning(LinkInterfaceLog) << "removeVehicleReference called with no vehicle references";
    }
}

void LinkInterface::_connectionRemoved(void)
{
    if (_vehicleReferenceCount == 0) {
        // Since there are no vehicles on the link we can disconnect it right now
        disconnect();
    } else {
        // If there are still vehicles on this link we allow communication lost to trigger and don't automatically disconect until all the vehicles go away
    }
}
