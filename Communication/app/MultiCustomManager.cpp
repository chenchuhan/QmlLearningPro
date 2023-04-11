#include "MultiCustomManager.h"


MultiCustomManager::MultiCustomManager()
{
//    _customerProtocol = new CustomerProtocol();

    //心跳包的确认来建立一个用户端; 目前由用户操作决定
//    connect(_customerProtocol, &MAVLinkProtocol::vehicleHeartbeatInfo, this, &MultiVehicleManager::_vehicleHeartbeatInfo);
}

MultiCustomManager::~MultiCustomManager() {

}


void MultiCustomManager::CreateCustomer(LinkInterface *link) {
    qDebug() << QString("link name is %1").arg(link->linkConfiguration()->name());
}
