#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QTranslator>
#include <QDebug>
#include <QQmlContext>
#include "TranslationTest.h"


void setLanguage(QGuiApplication *app) {

    QLocale locale = QLocale::system();

    if(locale.language() == QLocale::Chinese)
    {
        QTranslator *translator = new QTranslator(app);
        ///--以下三种方法都可以加载翻译文件
        if(translator->load(":/translations/zh_CN.qm"))
//          if(translator->load(locale, ":/translations/zh_CN.qm", "", ":/i18n"))
//          if (translator->load(locale, "zh_CN", ".", ":/translations", ".qm"))
        {
            app->installTranslator(translator);
        }
        else {
            qDebug() << "Error loading source localization ";
        }
    }
}

static QObject *backendInterfaceProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new TranslationTest();
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    setLanguage(&app);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("TranslationTest", new TranslationTest);  //[flag3]
//    qmlRegisterSingletonType<TranslationTest>   ("CC.QML",     1, 0, "TranslationTest",     backendInterfaceProvider);

    engine.load(url);



    return app.exec();
}
