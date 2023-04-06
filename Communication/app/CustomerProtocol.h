#ifndef CUSTOMER_H
#define CUSTOMER_H

#include <QObject>

#include "LinkInterface.h"

class Customer : public QObject
{
    Q_OBJECT

public:
    Customer();

public slots:
    void receiveBytes(LinkInterface* link, QByteArray b);

};

enum SANHANG_PRO_STATE{
    PROTOCOL_DEFAULT = 0,
    PROTOCOL_HEAD,
    PROTOCOL_LEN1,
    PROTOCOL_LEN2,
    PROTOCOL_ID1,
    PROTOCOL_ID2,
    PROTOCOL_CMD,
    PROTOCOL_DATA,
    PROTOCOL_CRC1,
    PROTOCOL_CRC2
};

#endif // CUSTOMER_H
