#include "fermatspiralpath.h"

#define M_PI  (3.14159265358979323846)
#define M_RAD (180/M_PI)


FermatSpiralPath::FermatSpiralPath(void):
    _radius(60),
    _spacing(20)
{
    SpiralPathAdd();
}

void FermatSpiralPath::SpiralPathAdd() {

    QGeoCoordinate corCenter(30.6562, 104.0657);

    QGeoCoordinate cor;

    _points.clear();
    _points.append(QVariant::fromValue(corCenter));

    double D_I = 0;                            //内径
    double N = _radius/_spacing;               //圈数

    const int pointCount = 500;
    for (int i=0; i<pointCount; ++i)
    {

      double phi = i/static_cast<double>(pointCount-1);

      cor = corCenter.atDistanceAndAzimuth(D_I + _radius*phi, static_cast<double>(N*phi * 2*M_PI*M_RAD));
      _points.append(QVariant::fromValue(cor));

    }

    pointsChanged();
}

void FermatSpiralPath::setRadius(const qreal &radius)
{
    if( radius  != 0.0) {
        _radius = radius;
        SpiralPathAdd();
    }
}

void FermatSpiralPath::setSpacing(const qreal &spacing)
{
    if( spacing  != 0.0) {
        _spacing = spacing;
        SpiralPathAdd();
    }
}
