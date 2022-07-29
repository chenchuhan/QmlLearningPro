#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "TCPClient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    ///init
    QString applicationName = QStringLiteral("NetTools");
    QString orgName =  QStringLiteral("CCH");
    QString orgDomain = QStringLiteral("CCH");
    app.setApplicationName(applicationName);
    app.setOrganizationName(orgName);
    app.setOrganizationDomain(orgDomain);
    QSettings::setDefaultFormat(QSettings::IniFormat);

    QQmlApplicationEngine engine;

    engine.addImportPath(QStringLiteral("qrc:/qml"));
    qmlRegisterType<TCPClient>    ("CC.Nettools",       1, 0,  "TCPClient");

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
