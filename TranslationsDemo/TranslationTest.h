#ifndef TRANSLATIONTEST_H
#define TRANSLATIONTEST_H

#include <QGuiApplication>
#include <QObject>

extern QGuiApplication* _app;


class TranslationTest : public QObject
{
    Q_OBJECT
public:
    explicit TranslationTest(QObject *parent = nullptr);

    enum Mode {
        STABILIZE   = 0,   // hold level position
        ALT_HOLD ,
        POS_HOLD
    };

    Q_PROPERTY(QStringList qStringListTest      READ GetQStringList       CONSTANT)
//    QStringList rangeTypeNames () { return  _rangeTypeNames; }

    QString AppTranslate(const char* cchar);

    Q_INVOKABLE QString globalGreeting(int type) ;
    Q_INVOKABLE QStringList GetQStringList();

signals:

public slots:

private:
    static const char *greetingStrings[];
    static const QStringList _rangeTypeNames;

};

#endif // TRANSLATIONTEST_H
