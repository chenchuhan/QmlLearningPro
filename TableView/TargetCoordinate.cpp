#include "TargetCoordinate.h"
#include <QDebug>

TargetCoordinate::TargetCoordinate(QObject* parent)
    :QAbstractTableModel(parent)
{
    _tmplat = 28.1;
    _tmplng = 113.1;
    _tmpalt = 30;

    QGeoCoordinate _Coordinate1(_tmplat, _tmplng, _tmpalt);
    TestAdd();
    QGeoCoordinate _Coordinate2(_tmplat, _tmplng, _tmpalt);
    TestAdd();

    addCoordinate(_Coordinate1);
    addCoordinate(_Coordinate2);

    qDebug() << "init" ;
}



QGeoCoordinate TargetCoordinate::getCoor(void) {
    TestAdd();

    QGeoCoordinate _Coordinate(_tmplat, _tmplng, _tmpalt);

    qDebug() << "_Coordinate1" << _Coordinate;

    return _Coordinate;//QGeoCoordinate(_tmplat, _tmplng, _tmpalt);
}

//Qml 中调用
//row: 插入的当前行数
//count: 插入的行的数量（默认1行）
int TargetCoordinate::insertRowsCoor(int row, int count) {

    qDebug() << "row" << row;

    //与 endInsertRows 配对使用，以确保模型的内部数据和视图保持一致。
    beginInsertRows(QModelIndex(), row,  row + count - 1);

    //插入新的数据项
    for (int i = 0; i < count; ++i) {
        m_coordinates.insert(row, getCoor());
    }



    endInsertRows();

    return row;       // 返回插入的行的索引
}

//Qml 中调用
//row: 插入的当前行数
void TargetCoordinate::removeRowsCoor(int row) {

    qDebug() << "row" << row;

    beginRemoveRows(QModelIndex(), row,  row);

    m_coordinates.removeAt(row);

    endRemoveRows();
}



TargetCoordinate::~TargetCoordinate()
{

}

int TargetCoordinate::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
//    qDebug() << "enter rowCount" <<  m_coordinates.count();
    return m_coordinates.count();
}

int TargetCoordinate::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 3; // 假设每个坐标组有三个属性：x和y,z
}


QAbstractItemModel *TargetCoordinate::model()
{
//    qDebug() << "enter model" ;
    return this;
}


//为每个角色提供一个名称，主要用于 QML 绑定。
QHash<int, QByteArray> TargetCoordinate::roleNames() const
{
//    qDebug() << "enter roleNames" ;

    QHash<int, QByteArray> roles;

//    roles.insert(numRole,  "seq");
    roles.insert(lngRole,  "lng");
    roles.insert(latRole,  "lat");
    roles.insert(altRole,  "alt");

    return roles;
}

//用户获取数据
//data() 函数用于返回模型中某个特定项的数据。此函数通常和 roleNames() 函数结合使用，以便为不同的角色返回相应的数据。
//视图（如ListView）中请求模型的数据时，视图会调用 data() 函数，并传递相应的 QModelIndex 和 role， data() 函数会根据这些参数返回对应的数据。
QVariant TargetCoordinate::data(const QModelIndex &index, int role) const
{
//    qDebug() << "enter 1" << index;

    if (!index.isValid())
        return QVariant();

    if (index.row() < 0 || index.row() >= m_coordinates.count())
        return QVariant();

    const QGeoCoordinate &coordinate = m_coordinates.at(index.row());

    switch(role)
    {
//        case numRole:
//            return index.row() + 1;
        case lngRole:
            return QString::number(coordinate.longitude(), 'f', 6);
        case latRole:
            return QString::number(coordinate.latitude(), 'f', 6);
        case altRole:
            return QString::number(coordinate.altitude(), 'f', 2);
    }

    return QVariant();
}

//提供模型的表头信息
/*section: 表示行或列的索引（从0开始）。
    例如，如果 orientation 是 Qt::Horizontal，那么 section 就表示列号； 如果 orientation 是 Qt::Vertical，那么 section 表示行号。
//orientation: 指定是水平（列）还是垂直（行）表头，使用 Qt::Horizontal 或 Qt::Vertical。
//role: 请求的角色，默认是 Qt::DisplayRole，表示通常请求的是用于显示的数据。其他可能的角色包括 Qt::DecorationRole（装饰用，例如图标）等。
*/
QVariant TargetCoordinate::headerData(int section, Qt::Orientation orientation, int role) const
{

    if (role != Qt::DisplayRole)
        return QVariant();

    /* 当请求的方向为 Qt::Horizontal 时，我们返回与请求的 section（列索引）相关的表头数据。*/
    if (orientation == Qt::Horizontal) {
        if (section == 0)
            return tr("lng");
        else if (section == 1)
            return tr("lat");
        else if (section == 2)
            return tr("alt");
    }

    return QVariant();
}

//用于返回模型中某个项的特性标志（flags）。这些标志指示该项是否可选中、可编辑、可拖放等行为。通过重写 flags() 函数，你可以控制模型中每个项的交互行为。
Qt::ItemFlags TargetCoordinate::flags(const QModelIndex &index) const
{
    qDebug() << "flags()" ;

    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable | QAbstractTableModel::flags(index);
}

/* 用户用于更新数据
1. 编辑数据: 当用户在视图中编辑数据（如在表格单元格中输入文本或选择复选框）时，视图会调用 setData() 函数，模型根据提供的新数据更新相应的项。
2. 拖放操作: 如果支持拖放操作，当数据被放置到模型中的某个位置时，setData() 可能会被调用以插入新数据。
3. 批量数据更新: 你可以在外部批量修改模型的数据，每次修改后调用 setData() 更新特定的项
*/
bool TargetCoordinate::setData(const QModelIndex &index, const QVariant &value, int role)
{

//    qDebug() << "enter setData" << index;

    if (!index.isValid() || role != Qt::EditRole)
        return false;

    if (index.row() < 0 || index.row() >= m_coordinates.count())
        return false;

    QGeoCoordinate &coordinate = m_coordinates[index.row()];
    if (index.column() == 0)
        coordinate.setLongitude(value.toDouble());
    else if (index.column() == 1)
        coordinate.setLatitude(value.toDouble());
    else if (index.column() == 2)
        coordinate.setAltitude(value.toDouble());

    //表示仅有一个单元格的数据发生了更改
    emit dataChanged(index, index);

    return true;
}

void TargetCoordinate::addCoordinate(const QGeoCoordinate &coordinate)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    m_coordinates.append(coordinate);

    endInsertRows();

//    qDebug() << "m_coordinates :" << m_coordinates;
}

void TargetCoordinate::removeCoordinate(int row)
{
    if (row < 0 || row >= m_coordinates.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_coordinates.removeAt(row);
    endRemoveRows();
}

void TargetCoordinate::refreshTableView(void)
{
    emit dataChanged(index(0, 0), index(rowCount() - 1, columnCount() - 1));
}

QGeoCoordinate TargetCoordinate::getCoordinate(int row) const
{
    qDebug() << "getCoordinate()" ;
    if (row < 0 || row >= m_coordinates.count())
        return QGeoCoordinate();

    return m_coordinates.at(row);
}


void TargetCoordinate::TestAdd() {
    _tmplat = _tmplat + 0.1;
    _tmplng = _tmplng + 0.2;
    _tmpalt = _tmpalt + 10;
}




