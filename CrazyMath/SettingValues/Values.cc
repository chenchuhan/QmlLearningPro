#include "Values.h"
#include <QSettings>
#include <qdebug.h>

const char* Values::_groupKey =      "values";
const char* Values::_bestScoreKey =  "bestScore";

Values::Values(void)
{
    QSettings settings;
    settings.beginGroup(_groupKey);

    //获取初值
    _bestScore = settings.value(_bestScoreKey).toInt();
    //更新 qml 值
    emit bestScoreChanged(_bestScore);

    qDebug() <<"Setting fileName is :" <<settings.fileName();
    qDebug() <<"_bestScore is :" << _bestScore;
}

void Values::setBestScore(const int& bestScore)
{
    QSettings settings;

    settings.beginGroup(_groupKey);
    settings.setValue(_bestScoreKey, bestScore);

    _bestScore = bestScore;
    emit bestScoreChanged(_bestScore);

    qDebug() <<"_bestScore is :" << _bestScore;
}

