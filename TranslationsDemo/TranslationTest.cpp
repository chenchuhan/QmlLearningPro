#include "TranslationTest.h"

QGuiApplication* _app = nullptr;


const QStringList TranslationTest::_rangeTypeNames = {
    _app->translate( "ColorTest", QT_TRANSLATE_NOOP("ColorTest", "red")),
    _app->translate( "ColorTest", QT_TRANSLATE_NOOP("ColorTest", "blue")),
    _app->translate( "ColorTest", QT_TRANSLATE_NOOP("ColorTest", "yellow"))
};


const  char *TranslationTest::greetingStrings[] = {
    QT_TRANSLATE_NOOP( "FriendlyConversation",  "Hello"),
    QT_TRANSLATE_NOOP( "FriendlyConversation",  "Goodbye"),
    QT_TRANSLATE_NOOP( "FriendlyConversation",  "How are you?")
};

QString TranslationTest::globalGreeting(int type)
{
    return _app->translate( "FriendlyConversation", greetingStrings[type]);
}

TranslationTest::TranslationTest(QObject *parent) : QObject(parent)
{
}

//QStringList TranslationTest::GetQStringList() {
//    QStringList tmp;
//    tmp.append(_app->translate( "ColorTest", QT_TRANSLATE_NOOP("ColorTest", "red")));
//    tmp.append(_app->translate( "ColorTest", QT_TRANSLATE_NOOP("ColorTest", "blue")));
//    tmp.append(_app->translate( "ColorTest", QT_TRANSLATE_NOOP("ColorTest", "yellow")));

//    return  tmp;
//}

QString TranslationTest::AppTranslate(const char* cchar)
{
    const char* context = "ContextTest";
    return _app->translate( context, QT_TRANSLATE_NOOP(context, cchar));
}

QStringList TranslationTest::GetQStringList() {
    QStringList tmp;

    QMap<uint32_t, QString> flightMode = {
        { STABILIZE,    AppTranslate("Stabilize")},
        { ALT_HOLD,     AppTranslate("Altitude Hold")},
        { POS_HOLD,     AppTranslate("Position Hold")}
    };

    for(uint32_t i: flightMode.keys()) {
        tmp.append(flightMode[i]);  // tmp << enumToString[i];
    }
    return  tmp;
}







