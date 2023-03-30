#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "UserApplication.h"
#include <QSslSocket>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    UserApplication* app = new UserApplication(argc, argv);

    app->_initCommon(); //qmlRegisterType

    app->_initForNormalAppBoot();   //    qmlEngine->addImportPath("qrc:/qml");

    app->exec();

    app->_shutdown();
    delete app;

    qDebug() << "After app delete";
}

////    QGuiApplication app(argc, argv);
////    QQmlApplicationEngine engine;
////    qmlRegisterType<QmlPalette>     ("Palette", 1, 0, "Palette");
//    engine.addImportPath(QStringLiteral("qrc:/qml"));
////    engine.addImportPath(QStringLiteral("qrc:/qml"));
////    engine.addImportPath(QStringLiteral("qrc:/qml/Communication/QmlFile"));
////    engine.addImportPath(QStringLiteral("qrc:/qml/src/QmlControls"));

//    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
//                     &app, [url](QObject *obj, const QUrl &objUrl) {
//        if (!obj && url == objUrl)
//            QCoreApplication::exit(-1);
//    }, Qt::QueuedConnection);
//    engine.load(url);

//    return app.exec();
//}
