#ifndef MATH_PROBLEM_H
#define MATH_PROBLEM_H

#include <QObject>
#include <QString>

//using namespace::std;

class MathProblem : public QObject {

    Q_OBJECT

public:
    MathProblem(QObject *parent = nullptr);
    ~MathProblem();

    Q_PROPERTY(bool isRight     READ isRight   NOTIFY isRightChanged)

    bool isRight    ();

    Q_INVOKABLE QString nextMath();  //Q_INVOKABLE

signals:
    void isRightChanged         (bool isRight);

private:
    int             newIdx;
    bool            _isRight;
    int             _mathCount;

    static const char * _problems[];
    static const int    _answers[];
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
