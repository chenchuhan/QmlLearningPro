#ifndef Values_H
#define Values_H

#include <QObject>

class Values : public QObject
{
    Q_OBJECT
    
public:
    Values(void);

    Q_PROPERTY(int bestScore READ bestScore WRITE setBestScore NOTIFY bestScoreChanged)

    int bestScore(void) const { return _bestScore; }

    void setBestScore(const int& bestScore);


signals:
    void bestScoreChanged(int bestScore);


private:
    int _bestScore;

    static const char* _groupKey;
    static const char* _bestScoreKey;
};

#endif
