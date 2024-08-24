
#ifndef TCPClient_H
#define TCPClient_H

#include <QObject>

#include <QTcpServer>           //监听套接字
#include <QTcpSocket>           //通信套接字
#include <QAbstractSocket>

#include <qtimer.h>
#include <QMetaEnum>
#include <QtNetwork>
#include "qloggingcategory.h"

class TCPClient : public QThread
{
    Q_OBJECT

public:
    /*explicit*/ TCPClient(/*QObject *parent = nullptr*/);
//    TCPClient(void);
    ~TCPClient();

    ///--Base
    Q_PROPERTY(bool         isConnected      READ isConnected    WRITE  setIsConnected       NOTIFY isConnectedChanged)
    Q_PROPERTY(int          tcpServerPort    READ tcpServerPort  WRITE  setTcpServerPort     NOTIFY tcpServerPortChanged)
    Q_PROPERTY(QString      tcpServerIP      READ tcpServerIP    WRITE  setTcpServerIP       NOTIFY tcpServerIPChanged)

    Q_PROPERTY(QString      rxData           READ rxData         NOTIFY rxDataChanged)
    Q_PROPERTY(QString      deviceIP         READ deviceIP       NOTIFY deviceIPChanged)
    Q_PROPERTY(QString      rcvState         READ rcvState       WRITE  setRcvState)

    ///--READ
    bool    isConnected   () const { return _isConnected; }
    int    tcpServerPort   () const {return _tcpServerPort; }
    QString  tcpServerIP   () const { return _tcpServerIP; }

    QString  rxData   () const { return _rxData; }
    QString  deviceIP   () const { return _deviceIP; }
    QString  rcvState   () const { return _rcvState; }


    ///--WRITE
    void setTcpServerPort    (const int port);
    void setTcpServerIP      (const QString ip);
    void setIsConnected      (const bool);
    void setRcvState         (const QString state);


    ///--连接和断开的接口
    Q_INVOKABLE bool    connect(QString ip,  int port);
    Q_INVOKABLE bool    disconnect          (void);

    ///--具体的发送和接收函数
//    Q_INVOKABLE bool    start               (uint16_t port, QHostAddress addr = QHostAddress::AnyIPv4);
    Q_INVOKABLE bool    sendData            (const QString info, unsigned char suffixIndex, QString state);
    Q_INVOKABLE bool    sendXY              (int x, int y);

    Q_INVOKABLE QString getLocalIP             ();

    void ReceiveParse(const QByteArray &buf);
    QString suffixHandle(unsigned char index);


    void run() override;

signals:
    ///--信号
    void isConnectedChanged      (const bool isConnect);
    void tcpServerPortChanged    (const int port);
    void tcpServerIPChanged      (const QString ip);
    void gimbalPitchChanged      (qreal pitch);
    void rxDataChanged           (const QString rxData);
    void deviceIPChanged         (const QString deviceIP);

private slots:
    void _socketError   (QAbstractSocket::SocketError socketError);
    void readData();
    void connectHandle(void);
    void getNetIP(void);


private:
    int                  _tcpServerPort = 0;
    QString              _tcpServerIP = "";         //服务器IP

    QTcpSocket*         _tcpSocket;
    bool                _isConnected;
    QTimer*              _connectTimer = nullptr;
    QTimer              _getNetIP;



    char _add = 0;

    int                             _dir = 0;

    QString _rxData = "";
    int _rxAllLen = 0;

    // 文本编码
    QTextCodec *textCodec;

    QString _deviceIP;
    QString _rcvState = "ASCII";


    static const char* _groupKey;
    static const char* _ipKey;
    static const char* _portKey;
};

class TCPClientController : public QObject
{
    Q_OBJECT
public:
    TCPClientController(QObject *parent = nullptr);

    ~TCPClientController();

    Q_PROPERTY(TCPClient * tcpClient   READ tcpClient  NOTIFY tcpClientChanged)
    TCPClient * tcpClient() const { return  _tcpClient;}

signals:
    void tcpClientChanged(TCPClient * tcpClient);

private:
    TCPClient *_tcpClient;
};
#endif
