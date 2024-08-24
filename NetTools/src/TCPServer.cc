#include <QtQml>
#include "TCPServer.h"
#include "qdebug.h"


TCPServer::TCPServer(QObject* parent)
    : QObject               (parent)
{
//    _dirTimer.setSingleShot(true);
//    _dirTimer.setInterval(60);
//    connect(&_dirTimer, &QTimer::timeout, this, &TCPServer::sendDirection);

    //start_cch_20220512
//    this->start("9999");
}

//qml 中
void TCPServer::timerStart(int dir) {

    if(!_dirTimer.isActive()) {
        _dir = dir;
        _dirTimer.start();
    }
    else {
    }
}


//-----------------------------------------------------------------------------
bool TCPServer::disconnect(void)
{
    bool res = (_tcpSocket || _tcpServer);
    if(_tcpSocket) {
        qDebug() << "Close Taisync TCP socket on port" << _tcpSocket->localPort();
        QObject::disconnect(_tcpSocket, &QIODevice::readyRead, this, &TCPServer::readData);
        _tcpSocket->disconnectFromHost(); // Disconnect tcp
        _tcpSocket->close();
        _tcpSocket->deleteLater();
        _tcpSocket = nullptr;
    }
    if(_tcpServer) {
        qDebug()  << "Close TCPServer TCP server on port" << _tcpServer->serverPort();
        _tcpServer->close();
        _tcpServer->deleteLater();
        _tcpServer = nullptr;
    }
    return res;
}

void TCPServer::start(QString port)
//bool TCPServer::start(uint16_t port, QHostAddress addr)
{
    disconnect();
    QHostAddress addr = QHostAddress::AnyIPv4;

    bool isOK;
    uint16_t uint16Port = port.toUShort(&isOK);

    if(!_tcpServer) {
        qDebug() << "Listen for TCPServer TCP on port: " << uint16Port;
//            qCDebug(TCPServer) << "Listen for TCPServer TCP on port" << port;
        _tcpServer = new QTcpServer(this);
        QObject::connect(_tcpServer, &QTcpServer::newConnection, this, &TCPServer::newConnection);
        _tcpServer->listen(QHostAddress::AnyIPv4, uint16Port);
//        _isConnected = true;
//        isConnectedChanged(_isConnected);
//        QList<QHostAddress> list = QNetworkInterface::allAddresses();
//        foreach (QHostAddress address, list)
//        {
//            if(address.protocol() == QAbstractSocket::IPv4Protocol)
//            {
//                if(address.toString().contains("127.0.")) continue;
//                 qDebug() << "Address : " << address.toString();
//            }
//            else if (address.isNull())  // 主机地址为空
//                continue;
//        }
    }
}

//-----------------------------------------------------------------------------
void TCPServer::newConnection()
{
//    qCDebug(TaisyncLog) << "New TCPServer TCP Connection on port" << _tcpServer->serverPort();
//    if(_tcpSocket) {
//        _tcpSocket->close();
//        _tcpSocket->deleteLater();
//    }
    _tcpSocket = _tcpServer->nextPendingConnection();
    if(_tcpSocket) {
        //取出建立好连接的的套接字
//        _tcpSocket = _tcpServer->nextPendingConnection();
        //获取对方的IP和端口
        QString  ip = _tcpSocket->peerAddress().toString();
        quint16  port = _tcpSocket->peerPort();
        QString  temp = QString("server connect %1:%2 success").arg(ip).arg(port);

//        qDebug() << temp;
        QObject::connect(_tcpSocket, &QIODevice::readyRead, this, &TCPServer::readData);
//        QObject::connect(_tcpSocket, &QAbstractSocket::disconnected, this, &TaisyncHandler::_socketDisconnected);
//        emit connected();

    } else {
//        qCWarning(TaisyncLog) << "New Taisync TCP Connection provided no socket";
        qDebug() << "New Taisync TCP Connection provided no socket";
    }
}



void TCPServer::ReceiveParse(const QByteArray &buf){
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
        _gimbalPitch =  static_cast<qreal>(tmp16) / 100.0;
        //gimbalPitch:  -120 ~  -90 ~  0 ~ 60
//        qDebug("_gimbalPitch is %f", _gimbalPitch);
        emit gimbalPitchChanged(_gimbalPitch);
    }
}

//-----------------------------------------------------------------------------
void TCPServer::readData()
{
    if(_tcpSocket) {

        qint64 byteCount = _tcpSocket->bytesAvailable();

        if (byteCount)
        {
            QByteArray buffer;
            buffer.resize(byteCount);
            _tcpSocket->read(buffer.data(), buffer.size());
//            qDebug() << buffer;
//            unsigned char* p = (unsigned char*)buffer.data();
//            for(int i = 0; i < buffer.size(); i++)
//            {
//                qDebug("%.2x ", p[i]);
//            }
            ReceiveParse(buffer);
        }
    }
}

//    QByteArray data = _tcpSocket->readAll();
//    if (data.length() <= 0)     return;
//    QString strData = "Receive: " + data;
//    qDebug() << strData;




bool TCPServer::sendData(const QString info)
{
    if (!_tcpServer->isListening())
    {
        qDebug()  << "qtcpServer is null";
        return false;
    }

    if(!_tcpServer)
    {
        qDebug()<< "qtcpSocket is null";
        return false;
    }
    //给对方发送数据，使用套接字是tcpSocket
//    qtcpSocket->waitForBytesWritten();
    /*qint64 _i = */_tcpSocket->write(info.toUtf8().data());
    _tcpSocket->flush();
//    qDebug()  << "server send qml data length:" + QString::number(_i,10);
    return true;
}

bool TCPServer::sendValue(char value) {
    QByteArray add;

    if(value>100 || value<1)
        return  false;

    add.resize(9);
    add[0] = 0x68;
    add[1] = 0x01;
    add[2] = 0x68;
    add[3] = 0x03;
    add[4] = value;
    add[5] = 0x00;
    add[6] = 0x00;
    add[7] = 0x00;
    add[8] = 0x68;

    if(_tcpSocket) {
        _tcpSocket->write(add);
        _tcpSocket->flush();
//        qDebug()  << "add" <<add.toHex();
    }
    else {
        qDebug()  << "please open tcp!!!";

    }
    return true;
}

//start_cch_20220518
bool TCPServer::sendUpDown(int dir){

    QByteArray add;
    add.resize(9);
    add[0] = 0x68;
    add[1] = 0x01;
    add[2] = 0x68;
    add[3] = 0x05;
    add[5] = 0x00;
    add[6] = 0x00;
    add[7] = 0x00;
    add[8] = 0x68;
    add[4] = static_cast<char>(dir);

    if(_tcpSocket) {
        _tcpSocket->write(add);
        _tcpSocket->flush();
    }
    else {
        qDebug()  << "please open tcp!!!";
    }
    return true;
}

bool TCPServer::sendDataAdd(void) {
    QByteArray add;

     _add +=5;
     if(_add > 100) {_add = 100;}

    add.resize(9);
    add[0] = 0x68;
    add[1] = 0x01;
    add[2] = 0x68;
    add[3] = 0x03;
    add[4] = _add;
    add[5] = 0x00;
    add[6] = 0x00;
    add[7] = 0x00;
    add[8] = 0x68;

    if(_tcpSocket) {

        _tcpSocket->write(add);
        _tcpSocket->flush();
//        qDebug()  << "add" <<add.toHex();
    }
    else {
//        qDebug()  << "please open tcp!!!";
    }
    return true;
}


void TCPServer::setServerPort    (const quint16 sp) {

    if(_serverPort != sp) {
        _serverPort = sp;
    }
}
