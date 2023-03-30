/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/**
 * @file
 *   @brief Implementation of class UserApplication
 *
 *   @author Lorenz Meier <mavteam@student.ethz.ch>
 *
 */
#include <QFile>
#include <QFlags>
#include <QPixmap>
#include <QDesktopWidget>
#include <QPainter>
#include <QStyleFactory>
#include <QAction>
#include <QStringListModel>
#include <QRegularExpression>
#include <QFontDatabase>
#include <QQuickWindow>
#include <QQuickImageProvider>
#include <QQuickStyle>
#include <QDebug>
#include <QObject>

#include <QQmlContext>
#include "UserApplication.h"
#include "UDPLink.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

//-module
#include "QmlPalette.h"

/* 省略掉:
 *
 * QSetting 名字版本
 * Qlog
 * Qtranslation
 * Palette
 * 字体
 * 消息打印等
 */

UserApplication* UserApplication::_app = nullptr;

UserApplication::UserApplication(int &argc, char* argv[])
    : QApplication          (argc, argv)
{
    //start_cch_20220706
    qDebug() << "UserApplication Qthread id is" << QThread::currentThread();

    _app = this;
//    Set settings format
//    _toolbox = new QGCToolbox(this);
//    _toolbox->setChildToolboxes();
}

UserApplication::~UserApplication()
{
    // Place shutdown code in _shutdown
    _linkManager = nullptr;
    _app = nullptr;
}

void UserApplication::_initCommon()
{
    static const char* kComm  =          "Comm";

    qmlRegisterType<QmlPalette>     ("Palette", 1, 0, "Palette");

//    //start_cch_20210715 valuesC +1
//    qmlRegisterType<ValuesController>               (kQGCControllers,                       1, 0, "ValuesController");
//    // Register Qml Singletons
//    qmlRegisterSingletonType<QGroundControlQmlGlobal>   ("QGroundControl",                          1, 0, "QGroundControl",         qgroundcontrolQmlGlobalSingletonFactory);
//    qmlRegisterSingletonType<ScreenToolsController>     ("QGroundControl.ScreenToolsController",    1, 0, "ScreenToolsController",  screenToolsControllerSingletonFactory);
}

QQmlApplicationEngine* UserApplication::createQmlApplicationEngine(QObject* parent)
{
    QQmlApplicationEngine* qmlEngine = new QQmlApplicationEngine(parent);
    qmlEngine->addImportPath("qrc:/qml");

    _linkManager = new LinkManager();

    qmlEngine->rootContext()->setContextProperty("LinkManager", _linkManager);  //[flag3]

    return qmlEngine;
}

bool UserApplication::_initForNormalAppBoot()
{
    QSettings settings;

    _qmlAppEngine = createQmlApplicationEngine(this);

    //createRootWindow
    _qmlAppEngine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    // Load known link configurations
//    toolbox()->linkManager()->loadLinkConfigurationList();

    // Connect links with flag AutoconnectLink
//    toolbox()->linkManager()->startAutoConnectedLinks();

    settings.sync();
    return true;
}

/// @brief Returns the UserApplication object singleton.
UserApplication*qgcApp(void)
{
    return UserApplication::_app;
}

void UserApplication::_shutdown()
{
    // Close out all Qml before we delete toolbox. This way we don't get all sorts of null reference complaints from Qml.
    delete _qmlAppEngine;
}

//QObject* UserApplication::_rootQmlObject()
//{
//    if (_qmlAppEngine && _qmlAppEngine->rootObjects().size())
//        return _qmlAppEngine->rootObjects()[0];
//    return nullptr;
//}

