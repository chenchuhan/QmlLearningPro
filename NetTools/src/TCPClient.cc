#include <QtQml>
#include "TCPClient.h"
#include "qdebug.h"
#include <QHostInfo>
#include <QSignalSpy>  // qt 添加 testlib
#include <iostream>
#include <string>
#include <stdio.h>
#include <QSettings>

using namespace std;


const char* TCPClient::_groupKey =    "TCPClient";
const char* TCPClient::_ipKey =       "tcpServerIP";
const char* TCPClient::_portKey =   "tcpServerPort";

//QGC_LOGGING_CATEGORY(TCPClient,  "TCPClient")
///--待增加的，定时器停止后，连接上了，而当连接断开的时候，需要重新启动定时器的

TCPClient::TCPClient(/*QObject* parent*/)
//    : QObject               (parent)
    : _tcpSocket            (nullptr)
    , _isConnected          (false)
{
    // 定义文本编码
    textCodec = QTextCodec::codecForName("UTF-8");

    QSettings settings;

    qDebug() << "Settings location" << settings.fileName() << "Is writable?:" << settings.isWritable();

    settings.beginGroup(_groupKey);
    _tcpServerIP =  settings.value(_ipKey).toString();
    _tcpServerPort = settings.value(_portKey).toInt();
    qDebug() << QString("get init1 ip: %1, port: %2").arg(_tcpServerIP).arg(_tcpServerPort);
    //第一次更新数据，如果表中没有数据的话
    if(_tcpServerIP.length() < 1) {
        _tcpServerIP = "192.168.1.12";
        settings.setValue(_ipKey, _tcpServerIP);
    }
    if(_tcpServerPort < 1) {
        _tcpServerPort = 60000;
        settings.setValue(_portKey, _tcpServerPort);
    }
    qDebug() << QString("get init2 ip: %1, port: %2").arg(_tcpServerIP).arg(_tcpServerPort);
    tcpServerIPChanged(_tcpServerIP);
    tcpServerPortChanged(_tcpServerPort);

    ///--需要开个定时器，5s 连接一次
    connectHandle();

    getNetIP();
    _getNetIP.setInterval(5000);
    QObject::connect(&_getNetIP, &QTimer::timeout, this, &TCPClient::getNetIP);
//    _getNetIP.setSingleShot(true);
    _getNetIP.start();

    qDebug() << "[TCPClient] Qthread id is" << QThread::currentThread();
}

TCPClient::~TCPClient()
{
    disconnect();
}

void TCPClient::run() {
    static int count = 0;
    count++;
    qDebug() << QString("run() times is %1").arg(count);
    qDebug() << "run() Qthread id is" << QThread::currentThread();

    _connectTimer = new QTimer();
    _connectTimer->setInterval(5000);
    QObject::connect(_connectTimer, &QTimer::timeout, this, &TCPClient::connectHandle);
//    _connectTimer.setSingleShot(true);
    _connectTimer->start();

    exec();
}

void TCPClient::getNetIP()
{
    QString ip = getLocalIP();
    if(ip != _deviceIP) {
        _deviceIP = ip;
        deviceIPChanged(_deviceIP);
    }
}


////-----------------------------初始化-----------------------------------///
//qml 中
void TCPClient::connectHandle()
{
    //如果已经连接断开后，_tcpSocket不为空的
    if(_tcpSocket) {
        if(_tcpSocket->state() == _tcpSocket->ConnectedState)  {
            setIsConnected(true);
//            qDebug("Connecting!!!!!!");
        }
        else {
            delete _tcpSocket;
            _tcpSocket = nullptr;
            setIsConnected(false);
        }
    }

    //第一次连接_tcpSocket 为空    _isConnected = false
    if(!_isConnected) {
        connect(_tcpServerIP, _tcpServerPort);
    }
}

///--ok
void TCPClient::_socketError(QAbstractSocket::SocketError socketError)
{
    Q_UNUSED(socketError)
//    qDebug() << QString("Error on link %1. Error on socket: %2.").arg(socketError).arg(_tcpSocket->errorString());
//    emit communicationError(tr("Link Error"), tr("Error on link %1. Error on socket: %2.").arg(_config->name()).arg(_socket->errorString()));
}

///--ok--qml 中连接和断开的按钮
bool TCPClient::connect(QString ip,  int port)
{
//    qDebug() << "ip: " << ip;
//    qDebug() << "prot: " << port;

    //先验证ip 和 端口：
    if(_tcpServerIP.length() > 7  && _tcpServerPort!=0) {
    }
    else {
//        qDebug("ip or port format error!!!");
        setIsConnected(false);
        return false;
    }

    //连接之前应该清空
//    _tcpSocket->deleteLater();          // Make sure delete happens on correct thread
    _tcpSocket = nullptr;

    if (_tcpSocket) {
//        qWarning() << "connect called while already connected";
        qDebug() << "connect called while already connected";
        return true;
    }

    Q_ASSERT(_tcpSocket == nullptr);
    _tcpSocket = new QTcpSocket(this);
    QObject::connect(_tcpSocket, &QIODevice::readyRead, this, &TCPClient::readData);

#if QT_VERSION < QT_VERSION_CHECK(5, 15, 0)
    QSignalSpy errorSpy(_tcpSocket, static_cast<void (QTcpSocket::*)(QAbstractSocket::SocketError)>(&QTcpSocket::error));
#else
    QSignalSpy errorSpy(_tcpSocket, &QAbstractSocket::errorOccurred);
#endif
#if QT_VERSION < QT_VERSION_CHECK(5, 15, 0)
    QObject::connect(_tcpSocket, static_cast<void (QTcpSocket::*)(QAbstractSocket::SocketError)>(&QTcpSocket::error),
                     this, &TCPClient::_socketError);  //连接错误发送提示
#else
    // QObject::connect(_tcpSocket, &QAbstractSocket::errorOccurred, this, &TCPLink::_socketError);
#endif

    _tcpServerIP = ip;
    _tcpServerPort =  port;
    _tcpSocket->connectToHost(_tcpServerIP,  static_cast<quint16>(_tcpServerPort));

    // Give the socket a second to connect to the other side otherwise error out
    if (!_tcpSocket->waitForConnected(1000))  //最多等待一秒  一般是秒连
    {
        // Whether a failed connection emits an error signal or not is platform specific.
        // So in cases where it is not emitted, we emit one ourselves.
        if (errorSpy.count() == 0) {
//              qDebug() << "Connect Error 1";
//            emit communicationError(tr("Link Error"), tr("Error on link %1. Connection failed").arg(_config->name()));
        }
//        qDebug() << "Connect Error 2";

        delete _tcpSocket;
        _tcpSocket = nullptr;
        setIsConnected(false);
        return false;
    }
    qDebug() << "Connect ok!!!";
    setIsConnected(true);

    return true;
}

///--ok--qml 断开
bool TCPClient::disconnect(void)
{
    if (_tcpSocket) {
        // This prevents stale signal from calling the link after it has been deleted
        QObject::disconnect(_tcpSocket, &QIODevice::readyRead, this, &TCPClient::readData);  //_readBytes
        _tcpSocket->disconnectFromHost(); // Disconnect tcp
        _tcpSocket->deleteLater();          // Make sure delete happens on correct thread
        _tcpSocket = nullptr;
        qDebug() << "Close TCP socke";
        setIsConnected(false);
    }
    return  true;
}

////-----------------------------数据收发-----------------------------------///
//4.1 接收服务器数据 (socket->readAll())
void TCPClient::readData()
{
//    QByteArray data = socket->readAll();

    if(_tcpSocket) {
        qint64 byteCount = _tcpSocket->bytesAvailable();
        if (byteCount)
        {
            QByteArray buffer;
            buffer.resize(static_cast<int>(byteCount));
            _tcpSocket->read(buffer.data(), buffer.size());

            ///传输给ui的

            QString dataTemp;
//            if(timestamp) // 时间戳
//            {
//                dataTemp.append(this->getCurrentTime());
//            }
            if(_rcvState == "ASCII")
            {
                dataTemp.append(textCodec->toUnicode(buffer));
            }
            else if(_rcvState == "HEX")
            {
                dataTemp.append(QString(buffer.toHex(' ')).toUpper()).append(" ");
            }

            _rxData =   dataTemp;//buffer.data();
            rxDataChanged(_rxData);
//            _rxAllLen += buffer.size(); //tc->toUnicode(this->TCPServer_dataBuf).length();
            qDebug() << "_rxData" << _rxData;
//            unsigned char* p = (unsigned char*)buffer.data();
//            for(int i = 0; i < buffer.size(); i++)
//            {
//                qDebug("%.2x ", p[i]);
//            }
//            ReceiveParse(buffer);
        }
    }
}

void TCPClient::ReceiveParse(const QByteArray &buf){
    unsigned char* p;
    p = (unsigned char*)buf.data();

    if((buf[0] == 0x68)
    && (buf[1] == 0x01)
    && (buf[2] == 0x68)
    && (buf[3] == 0x06)) {
//        int tmp16 =  ( static_cast<int>(buf.at(8)<<8) | buf.at(9));
        int tmp16 = /* ( static_cast<int>*/(p[8]<<8) | p[9];
//        qDebug("tmp16 is %d", tmp16);
        if(tmp16 > 65536-18000) {
            tmp16 = (65536 - 18000 - tmp16) + 100;// 180000 - (65536 - tmp16);
        }
        else if(tmp16 <= 18000){
            tmp16 = 18000 - tmp16;
        }
//        _gimbalPitch =  static_cast<qreal>(tmp16) / 100.0;
//        //gimbalPitch:  -120 ~  -90 ~  0 ~ 60
////        qDebug("_gimbalPitch is %f", _gimbalPitch);
//        emit gimbalPitchChanged(_gimbalPitch);
    }
}

QString TCPClient::getLocalIP(void) {

    ///--最常用的获取IP地址的方法
//    QString localHostName = QHostInfo::localHostName();
//    qDebug() << QString("计算机名：%1").arg(localHostName) ;
//    //获取 IP 地址
//    QHostInfo info = QHostInfo::fromName(localHostName);
//    //遍历地址，只获取 IPV4 地址
//    foreach(QHostAddress address,info.addresses()) {
//        if(address.protocol() == QAbstractSocket::IPv4Protocol)
//        {
//            qDebug() << QString("ipV4 地址%1").arg(address.toString()) ;
//        }
//    }

    bool running = false;
    QString retIP = "";

    QList<QNetworkInterface> nets = QNetworkInterface::allInterfaces();
        //获取所有网络接口的列表
    foreach(QNetworkInterface interface,  nets)
    {
        QString humanReadableName = interface.humanReadableName();
//        qDebug() << "humanReadableName:"<< humanReadableName;

        //移除虚拟机、本地、127.0.0.1
        if(humanReadableName.contains("VMware") ||
           humanReadableName.contains("本地") ||
           humanReadableName.contains("Loopback")) {
            continue;
        }

        //硬件地址 list
        QList<QNetworkAddressEntry> entryList = interface.addressEntries();
        //如果没有连接的网络，将返回第一个ip，有则返回有的连接

        //获取IP地址条目列表，每个条目中包含一个IP地址，一个子网掩码和一个广播地址
        foreach(QNetworkAddressEntry entry, entryList)
        {
            QHostAddress address = entry.ip();
            //if(address.protocol() == QAbstractSocket::IPv4Protocol) 与下面等效
            if( address.toIPv4Address()) {
//                qDebug() << QString("IP Address: %1").arg(address.toString()) ;
                //如果没有连接的网络，将返回第一个 ip
                if(!running)  {
                    running = true;
                    retIP = address.toString();
                }
                if(interface.flags().testFlag(QNetworkInterface::IsRunning )) {
//                     qDebug() << "[running]: " << address.toString() ;
                     return address.toString();
                }
            }
        }
    }
//    qDebug() << "[retIP]:" << retIP;
    return  retIP;
}

// 数据后缀处理
QString TCPClient::suffixHandle(unsigned char index)
{
    QString suffixTemp;
    switch(index)
    {
        case 0: suffixTemp = ""; break;
        case 1: suffixTemp = "\r"; break;
        case 2: suffixTemp = "\n"; break;
        case 3: suffixTemp = "\r\n"; break;
        case 4: suffixTemp = "\n\r"; break;
    }
    return suffixTemp;
}

bool TCPClient::sendData(QString info, unsigned char suffixIndex,  QString state)
{
    if(!_tcpSocket)
    {
        qDebug()<< "_tcpSocket is null";
        return false;
    }

    QByteArray transmitInfo;
    QString suffixTemp;
    suffixTemp = suffixHandle(suffixIndex);

    if(state == "ASCII") {
        //QString str = "abc123";
        //QByteArry data = str.toUtf8(); //输出data：abc123
        // 将获取的文本内容转换为QByteArray类型
        //transmitInfo =    info.toUtf8();
        // QString转QByteArray方法2
        transmitInfo = textCodec->fromUnicode(info.append(suffixTemp));
    } else if(state == "HEX") {
        // 将获取的文本内容转换为QByteArray类型后再转换为16进制并大写
        transmitInfo = QByteArray::fromHex(textCodec->fromUnicode(info.append(suffixTemp))).toUpper();
    }

//    const char * data = info.toUtf8().data();
    _tcpSocket->write(transmitInfo);

    _tcpSocket->flush();

    qDebug()  << QString("[data]:") << (transmitInfo);
    return true;
}

bool TCPClient::sendXY(int x, int y)
{
//    QByteArray add;
//    add.resize(9);
//    qDebug() << QString("!!!x:%1, y:%2").arg(x).arg(y)   ;

    if(x>4096 || x<1) {
        qDebug() << QString("x error: %1").arg(x)   ;
        return  false;
    }
    if(y>2160 || y<1) {
        qDebug() << QString("y error: %1").arg(y)   ;
        return  false;
    }

    unsigned char  data[13];

    data[0] = 0x68;
    data[1] = 0x01;
    data[2] = 0x68;
    data[3] = 0x07;
    data[4] = static_cast<uchar>(x & 0xff) ;
    data[5] = static_cast<uchar>(x>>8 & 0xff) ;
    data[6] = static_cast<uchar>(y & 0xff) ;
    data[7] = static_cast<uchar>(y>>8 & 0xff) ;
    data[8] = 0x00;
//    add[9] = 0x00;
//    add[10] = 0x00;
//    add[11] = 0x00;
//    add[12] = 0x00;

//    for(int i =0; i<4 ;i++){
////        qDebug() << QString("%1: %2").arg(i+4).arg(add[4+i]);
//        qDebug("i:%d: %d" ,i+4, data[4+i]);
//    }
    if(_tcpSocket) {
//         const char * data = info.toUtf8().data();
        _tcpSocket->write((const char *)data);
        _tcpSocket->flush();
    }
    else {
        qDebug()  << "please open tcp!!!";
    }
    return true;
}

///--------------------------其它---------------------------//
///

void TCPClient::setIsConnected(const bool isConnected) {
    if(_isConnected != isConnected) {


        _isConnected = isConnected;
        emit isConnectedChanged(_isConnected);
    }
}


void TCPClient::setTcpServerPort(const int port) {
    if(_tcpServerPort != port) {
        qDebug() << "setTcpServerPort() Qthread id is" << QThread::currentThread();

        _tcpServerPort = port;
        QSettings settings;
        settings.beginGroup(_groupKey);
        settings.setValue(_portKey, _tcpServerPort);
        connect(_tcpServerIP, _tcpServerPort);
    }
}

void TCPClient::setTcpServerIP (const QString ip) {
    if(_tcpServerIP != ip) {
        _tcpServerIP = ip;
        QSettings settings;
        settings.beginGroup(_groupKey);
        settings.setValue(_ipKey, _tcpServerIP);
        connect(_tcpServerIP, _tcpServerPort);
    }
}

void TCPClient::setRcvState (const QString state) {
    if(_rcvState != state) {
        _rcvState = state;
    }
}


TCPClientController::TCPClientController(QObject* parent)
    : QObject(parent)
{
      _tcpClient = new TCPClient();
      tcpClientChanged(_tcpClient);

      _tcpClient->start();

      qDebug() << "TCPClientController Qthread id is" << QThread::currentThread();
}

TCPClientController::~TCPClientController() {

}
