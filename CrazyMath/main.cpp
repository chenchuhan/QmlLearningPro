#pragma execution_character_set("utf-8")

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "MathProblem/MathProblem.h"
#include <QQmlContext>
#include "SettingValues/Values.h"
#include <QTextCodec>
#include <QTranslator>
#include <QDebug>


///--指定了名字，公司等，就不需要手动创建.ini配置文件了, 会自动创建ini文件
void setOrganization(void) {

    QCoreApplication::setOrganizationName("CrazyMath");
    QCoreApplication::setOrganizationDomain("CrazyMath.com");
    QCoreApplication::setApplicationName("CrazyMath");
}

///--翻译
void setLanguage(QGuiApplication *app) {

    QLocale locale = QLocale::system();

    if(locale.language() == QLocale::Chinese)
    {
        QTranslator *translator = new QTranslator(app);

        ///--以下三种方法都可以加载翻译文件
        if(translator->load(":/translations/zh_CN.qm"))
    //      if(translator->load(locale, ":/translations/zh_CN.qm", "", ":/i18n"))
    //      if (translator->load(locale, "zh_CN", ".", ":/translations", ".qm"))

        {
            app->installTranslator(translator);
        }
        else {
            qDebug() << "Error loading source localization ";
        }
    }
}

///--设置编码
void setCode(void) {
    #if (QT_VERSION <= QT_VERSION_CHECK(5,0,0))
    #if _MSC_VER
        QTextCodec *codec = QTextCodec::codecForName("gbk");
    #else
        QTextCodec *codec = QTextCodec::codecForName("utf-8");
    #endif
        QTextCodec::setCodecForLocale(codec);
        QTextCodec::setCodecForCStrings(codec);
        QTextCodec::setCodecForTr(codec);
    #else
        QTextCodec *codec = QTextCodec::codecForName("utf-8");
        QTextCodec::setCodecForLocale(codec);
    #endif
}

static QObject *backendInterfaceProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new MathProblem(/* need a QMediaPlayer* here*/);
}


//QGuiApplication* _app = nullptr;


int main(int argc, char *argv[])
{

    ///--设置编码
    setCode();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    ///--设置公司网址，QSetting 就可以直接用了
    setOrganization();

//    QGuiApplication app(argc, argv);
    _app = new QGuiApplication(argc, argv);

    ///--设置翻译
    setLanguage(_app);

    QQmlApplicationEngine engine;

    //install module 安装模块
    engine.addImportPath(QStringLiteral("qrc:/"));

    // C++ 和 QML 混合编程，方法一：
    engine.rootContext()->setContextProperty("MathProblem", new MathProblem);  //[flag3]

    qmlRegisterSingletonType<MathProblem>   ("CC.QML",     1, 0, "MathProblem",     backendInterfaceProvider);


    // C++ 和 QML  混合编程，方法二：
    qmlRegisterType<Values>       ("cc.Values",        1, 0, "Values");
    //具体网址：https://blog.csdn.net/qq_16504163/article/details/105189471

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     _app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return _app->exec();
}


