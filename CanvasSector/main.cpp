#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QDebug>

/////--中文测试
bool ChineseTest(void) {

    QString str = "为什么的2df.dasf为 d啊 ";
    int LowerCase, UpperCase; //大写，小写
    int space = 0;
    int digit, character; //数字，字符
    int chinese = 0; //中文
    digit = character = LowerCase = UpperCase = 0;
    for (int i = 0; i < str.size(); )
    {
        if (str[i] >= 'a' && str[i] <= 'z')
        {
            LowerCase ++;i++;
        }
        else if (str[i] >= 'A' && str[i] <= 'Z')
        {
            UpperCase ++;i++;
        }
        else if (str[i] >= '0' && str[i] <= '9')
        {
            digit ++;i++;
        }
        ////通过utf-8字节码进行判断
        else if (str[i] >= 0xE0){
            char c[3];
//            strncpy(&c[0], &str[i], 3);
            i+=3;
            chinese++;
        }
        else if (str[i] == ' ')
        {
            space++;i++;
        }
        else
        {
            character++;i++;
        }
    }
//    qDebug() << QString("大写");

    qDebug() << QString("大写%1个，小写%2个，数字%3个，字符%4个，汉字%5个，空格%6个\n").arg(UpperCase).arg(LowerCase).arg(digit).arg(character).arg(chinese).arg(space);
    return 0;
}

int main(int argc, char *argv[])
{
    ChineseTest();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
