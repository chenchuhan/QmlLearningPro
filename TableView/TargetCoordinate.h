#ifndef LOESIMULATIONEVALUATION_H
#define LOESIMULATIONEVALUATION_H

#include <QObject>
#include <QVariantList>
#include <QGeoCoordinate>
#include <qabstractitemmodel.h>

class TargetCoordinate :  public QAbstractTableModel
{
    Q_OBJECT

public:

    TargetCoordinate(QObject* parent = nullptr);
    ~TargetCoordinate();

//    Q_PROPERTY(QmlObjectListModel*  mode       READ mode   /* WRITE  setMode*/         NOTIFY modeChanged)
    Q_PROPERTY(QVariantList*  mode       READ mode           NOTIFY modeChanged)
    QVariantList *mode (void)  {return  &_mode; }

    void InitTestData();
    void TestAdd();

    Q_INVOKABLE QAbstractItemModel *model();
    QGeoCoordinate getCoor(void);
    Q_INVOKABLE int insertRowsCoor(int row, int count) ;
    Q_INVOKABLE void removeRowsCoor(int row);
    Q_INVOKABLE void refreshTableView(void);

//    Q_INVOKABLE void testAddWayPoint();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    Q_INVOKABLE void addCoordinate(const QGeoCoordinate &coordinate);
    void removeCoordinate(int row);
    QGeoCoordinate getCoordinate(int row) const;

    QHash <int, QByteArray> roleNames() const override;
    enum TABLE_ITEM_ROLE
    {
        numRole = Qt::UserRole+1,
        lngRole ,
        latRole,
        altRole,

    };

signals:
    void modeChanged                               ();

public slots:

private:

    QHash<int, QByteArray> m_roleName;

    QList<QGeoCoordinate> m_coordinates;


    QVariantList              _mode;

    double _tmplat ;
    double _tmplng;
    double _tmpalt ;
};


#endif
