#pragma execution_character_set("utf-8")



#include "MathProblem.h"
#include <QDebug>
#include <QDateTime>

QGuiApplication* _app = nullptr;


const char *MathProblem::_problems[] = {
    "1 + 2 = ", "2 + 3 = ", "2 + 2 = ",
    "1 + 4 = ", "2 + 5 = ", "4 + 2 = ",
    "2 + 6 = ", "3 + 3 = ", "3 + 4 = ",
    "7 + 2 = ", "2 + 7 = ", "4 + 6 = ",
    "3 + 8 = ", "2 + 5 = ", "2 + 9 = ",
    "4 + 6 = ", "5 + 9 = ", "6 + 7 = ",
    "5 + 3 = ", "2 + 6 = ", "7 + 8 = ",
    "7 + 5 = ", "4 + 9 = ", "8 + 8 = ",
    "5 + 8 = ", "6 + 6 = ", "7 + 9 = ",
    "7 + 7 = ", "8 + 9 = ", "9 + 9 = ",
};
const int MathProblem::_answers[] = {
    3,  5,  4,
    5,  7,  6,
    8,  6,  7,
    9,  9,  10,
    11, 7,  11,
    10, 14, 13,
    8,  8,  15,
    12, 13, 16,
    13, 12, 16,
    14, 17, 18,
};

MathProblem::MathProblem(QObject *parent)
    : QObject(parent)
    , newIdx(0)
    , _isRight(true)
    , _mathCount(60)
{
    qsrand(QDateTime::currentDateTime().toTime_t());

     _test = tr("isTestEnglish");
     testChanged(_test);
}

MathProblem::~MathProblem() {
}

//返回下一组算术
QString MathProblem::nextMath()
{
    newIdx = qrand() % 30;
//    qDebug() << "newIdx" <<newIdx;

    //产生随机数 -1~1 之间
    int rand =  (qrand() % 3 - 1);
//    qDebug() << "rand" <<rand;

    //判断是否正确
    if(rand == 0)   _isRight = true;
    else            _isRight = false;

    int randAnswer = _answers[newIdx] + rand;
    return QString("%1%2").arg(_problems[newIdx]).arg(randAnswer);
}


bool MathProblem::isRight() {
//    qDebug() << "_isRight" <<_isRight;
    return  _isRight;
}

///-------------------------------------第一版本-----------------------------------
//#include "MathProblem.h"
//#include <QDateTime>

//const char *MathProblem::_problems[] = {
//    "1 + 2 = ", "2 + 3 = ", "2 + 2 = ","1 + 4 = ", "2 + 5 = "
//};
//const int MathProblem::_answers[] = {
//     3,  5,  4,  5,  7
//};

//MathProblem::MathProblem(QObject *parent)
//    : QObject(parent)
//    , newIdx(0)
//{
//    qsrand(QDateTime::currentDateTime().toTime_t());
//}

//MathProblem::~MathProblem() {
//}

////返回下一组算术
//QString MathProblem::nextMath()
//{
//    newIdx = qrand() % 5;

//    //随机的答案
//    int randAnswer = _answers[newIdx] + (qrand() % 7 - 3);   // 取 -3~3 的随机数

//    return QString("%1%2").arg(_problems[newIdx]).arg(randAnswer);
//}
