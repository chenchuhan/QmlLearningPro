#ifndef MultiCustomManager_H
#define MultiCustomManager_H

#include <QObject>

#include "CustomerProtocol.h"
//class CustomerProtocol;

class MultiCustomManager : public QObject
{
    Q_OBJECT

public:
    MultiCustomManager();
    ~MultiCustomManager();

public slots:

    void CreateCustomer (LinkInterface* link);

private:
//    CustomerProtocol*            _customerProtocol = nullptr;

};

#endif
