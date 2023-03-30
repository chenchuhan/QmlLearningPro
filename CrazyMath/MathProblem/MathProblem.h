#ifndef MATH_PROBLEM_H
#define MATH_PROBLEM_H

#include <QGuiApplication>

#include <QObject>
#include <QString>

//using namespace::std;
extern QGuiApplication* _app;

class MathProblem : public QObject {

    Q_OBJECT

public:
    MathProblem(QObject *parent = nullptr);
    ~MathProblem();

    Q_PROPERTY(bool isRight     READ isRight   NOTIFY isRightChanged)
    Q_PROPERTY(QString test     READ test   NOTIFY testChanged)

    bool isRight    ();
    QString test() const  {return _test;}

    Q_INVOKABLE QString nextMath();  //Q_INVOKABLE


signals:
    void isRightChanged         (bool isRight);
    void testChanged            (QString test);

private:
    int             newIdx;
    bool            _isRight;
    int             _mathCount;

    static const char * _problems[];
    static const int    _answers[];
    //start_cch_20220531

    QString _test;
};

#endif


///-------------------------------------第一版本-----------------------------------

//#ifndef MATH_PROBLEM_H
//#define MATH_PROBLEM_H

//#include <QObject>
//#include <QString>


//class MathProblem : public QObject {

//    Q_OBJECT

//public:
//    MathProblem(QObject *parent = nullptr);
//    ~MathProblem();

//    Q_INVOKABLE QString nextMath();  //Q_INVOKABLE

//private:
//    int newIdx;

//    static const char * _problems[];
//    static const int    _answers[];
//};

//#endif
