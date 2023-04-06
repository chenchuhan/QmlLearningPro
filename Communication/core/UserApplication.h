/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QApplication>
#include <QTimer>
#include <QElapsedTimer>
#include <QMap>
#include <QSet>
#include <QMetaMethod>
#include <QMetaObject>

#include "LinkManager.h"


// These private headers are require to implement the signal compress support below
#include <private/qthread_p.h>   //QT += core-private
#include <private/qobject_p.h>

#include "LinkConfiguration.h"

#ifdef QGC_RTLAB_ENABLED
#include "OpalLink.h"
#endif

// Work around circular header includes
class QQmlApplicationEngine;
class QGCSingleton;
class QGCToolbox;

/**
 * @brief The main application and management class.
 *
 * This class is started by the main method and provides
 * the central management unit of the groundstation application.
 *
 * Needs QApplication base to support QtCharts module. This way
 * we avoid application crashing on 5.12 when using the module.
 *
 * Note: `lastWindowClosed` will be sent by MessageBox popups and other
 * dialogs, that are spawned in QML, when they are closed
**/
class UserApplication : public QApplication
{
    Q_OBJECT
public:
    UserApplication(int &argc, char* argv[]);
    ~UserApplication();



    QQmlApplicationEngine* createQmlApplicationEngine(QObject* parent);


    // Still working on getting rid of this and using dependency injection instead for everything
//    QGCToolbox* toolbox(void) { return _toolbox; }

public slots:

signals:

public:
    // Although public, these methods are internal and should only be called by UnitTest code

    /// @brief Perform initialize which is common to both normal application running and unit tests.
    ///         Although public should only be called by main.
    void _initCommon();

    /// @brief Initialize the application for normal application boot. Or in other words we are not going to run
    ///         unit tests. Although public should only be called by main.
    bool _initForNormalAppBoot();

    /// @brief Initialize the application for normal application boot. Or in other words we are not going to run
    ///         unit tests. Although public should only be called by main.

    static UserApplication*  _app;   ///< Our own singleton. Should be reference directly by qgcApp

    LinkManager *GetLinkManager() { return  _linkManager; }

    void _shutdown();

public:
    // Although public, these methods are internal and should only be called by UnitTest code

private slots:

private:

    QQmlApplicationEngine* _qmlAppEngine        = nullptr;
    LinkManager* _linkManager = nullptr;
};

/// @brief Returns the UserApplication object singleton.
UserApplication* qgcApp(void);
