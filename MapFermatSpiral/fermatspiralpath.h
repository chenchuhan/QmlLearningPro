#ifndef FERMATSPIRALPATH_H
#define FERMATSPIRALPATH_H

#include "qgeocoordinate.h"
#include "qvariant.h"
#include "math.h"

#include <QObject>

class FermatSpiralPath : public QObject
{
    Q_OBJECT

public:
//    FermatSpiralPath(QObject* parent);

    FermatSpiralPath(void);

    Q_PROPERTY(QVariantList points  READ points  NOTIFY pointsChanged)

    Q_PROPERTY(qreal radius   READ  radius  WRITE setRadius)
    Q_PROPERTY(qreal spacing  READ  spacing  WRITE setSpacing)


    //read
    QVariantList points(void) const { return _points; }
    qreal radius(void) const { return _radius; }
    qreal spacing(void) const { return _spacing; }

    //write
    void setRadius (const qreal& radius);
    void setSpacing (const qreal& spacing);

    void SpiralPathAdd();

signals:
    void pointsChanged (void);

private:
    QVariantList _points;
    qreal _radius;
    qreal _spacing;
};

#endif // FERMATSPIRALPATH_H
