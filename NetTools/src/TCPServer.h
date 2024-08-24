#ifndef TCPServer_H
#define TCPServer_H

#include <QObject>

//#include <QTcpServer>           //监听套接字
//#include <QTcpSocket>           //通信套接字
//#include <QAbstractSocket>

#include <qtimer.h>
#include <QMetaEnum>

#include <QtNetwork>
#include "qloggingcategory.h"


//Q_DECLARE_LOGGING_CATEGORY(CcTcpServer_H)

class TCPServer : public QObject
{
    Q_OBJECT

public:
    /*explicit*/ TCPServer(QObject *parent = nullptr);


    Q_PROPERTY(quint16      serverPort       READ serverPort     WRITE setServerPort)
    Q_PROPERTY(bool         isConnected      READ isConnected    NOTIFY isConnectedChanged)
    Q_PROPERTY(qreal        gimbalPitch      READ gimbalPitch    NOTIFY  gimbalPitchChanged)


    //READ
    quint16  serverPort   () const { return _serverPort; }
    bool    isConnected   () const { return _isConnected; }
    qreal    gimbalPitch  () const { return _gimbalPitch; }

    //WRITE
    void setServerPort    (const quint16 sp);

    Q_INVOKABLE void    start               (QString port);
//    Q_INVOKABLE bool    start               (uint16_t port, QHostAddress addr = QHostAddress::AnyIPv4);
    Q_INVOKABLE bool    disconnect          (void);
    Q_INVOKABLE bool    sendData            (const QString info);

    Q_INVOKABLE bool    sendValue           (char value);
    Q_INVOKABLE bool    sendDataAdd         (void);

    Q_INVOKABLE void    timerStart          (int dir);

    Q_INVOKABLE bool    sendUpDown          (int dir);

    void ReceiveParse(const QByteArray &buf);


signals:
    void isConnectedChanged      (const bool isConnect);
    void gimbalPitchChanged      (qreal pitch);

private slots:
    void newConnection();
    void readData();

private:
    quint16         _serverPort;

    QTcpServer*     _tcpServer  = nullptr;
    QTcpSocket*     _tcpSocket  = nullptr;

    bool            _isConnected = false;
    char _add = 0;

    QTimer                          _dirTimer;
    int                             _dir = 0;
    qreal            _gimbalPitch = -90.0 ;

};

#endif
