/****************************************************************************
 * 日期： 2023/03/26
 * 参考： QGC 地面站的 QGCPalette.cc
 * 原文多了明暗色和使能失能
 *
 ****************************************************************************/


#include "QmlPalette.h"
#include <QApplication>   //QT += core gui widgets
#include <QPalette>

QList<QmlPalette*>   QmlPalette::_paletteObjects;

//QMap<int, QMap<int, QMap<QString, QColor>>> QmlPalette::_colorInfoMap;
QMap<QString, QColor> QmlPalette::_colorInfoMap;

QStringList QmlPalette::_colors;

QmlPalette::QmlPalette(QObject* parent) :
    QObject(parent)
{
    if (_colorInfoMap.isEmpty()) {
        _buildMap();
    }

    // We have to keep track of all QmlPalette objects in the system so we can signal theme change to all of them
    _paletteObjects += this;
}

QmlPalette::~QmlPalette()
{
    bool fSuccess = _paletteObjects.removeOne(this);
    if (!fSuccess) {
//        qWarning() << "Internal error";
    }
}

void QmlPalette::_buildMap()
{

    DECLARE_QML_SINGLE_COLOR(window,                "#ffffff")
    DECLARE_QML_SINGLE_COLOR(windowShadeLight,     "#828282")
    DECLARE_QML_SINGLE_COLOR(windowShade,           "#d9d9d9")
    DECLARE_QML_SINGLE_COLOR(windowShadeDark,       "#bdbdbd")
    DECLARE_QML_SINGLE_COLOR(text,                  "#000000")
    DECLARE_QML_SINGLE_COLOR(warningText,          "#cc0808")
    DECLARE_QML_SINGLE_COLOR(button,                "#ffffff")
    DECLARE_QML_SINGLE_COLOR(buttonText,           "#000000")
    DECLARE_QML_SINGLE_COLOR(buttonHighlight,       "#946120")
    DECLARE_QML_SINGLE_COLOR(buttonHighlightText,   "#ffffff")
    DECLARE_QML_SINGLE_COLOR(primaryButton,         "#8cb3be")
    DECLARE_QML_SINGLE_COLOR(primaryButtonText,     "#000000")
    DECLARE_QML_SINGLE_COLOR(textField,             "#ffffff")
    DECLARE_QML_SINGLE_COLOR(textFieldText,         "#000000")
    DECLARE_QML_SINGLE_COLOR(mapButton,             "#000000")
    DECLARE_QML_SINGLE_COLOR(mapButtonHighlight,    "#be781c")
    DECLARE_QML_SINGLE_COLOR(mapIndicator,          "#be781c")
    DECLARE_QML_SINGLE_COLOR(mapIndicatorChild,     "#766043")
    DECLARE_QML_SINGLE_COLOR(colorGreen,            "#009431")
    DECLARE_QML_SINGLE_COLOR(colorOrange,          "#b95604")
    DECLARE_QML_SINGLE_COLOR(colorRed,              "#ed3939")
    DECLARE_QML_SINGLE_COLOR(colorGrey,             "#808080")
    DECLARE_QML_SINGLE_COLOR(colorBlue,             "#1a72ff")
    DECLARE_QML_SINGLE_COLOR(alertBackground,      "#eecc44")
    DECLARE_QML_SINGLE_COLOR(alertBorder,           "#808080")
    DECLARE_QML_SINGLE_COLOR(alertText,            "#000000")
    DECLARE_QML_SINGLE_COLOR(missionItemEditor,     "#dbfef8")
    DECLARE_QML_SINGLE_COLOR(toolStripHoverColor,   "#9D9D9D")
    DECLARE_QML_SINGLE_COLOR(statusFailedText,      "#000000")
    DECLARE_QML_SINGLE_COLOR(statusPassedText,      "#000000")
    DECLARE_QML_SINGLE_COLOR(statusPendingText,     "#000000")
    DECLARE_QML_SINGLE_COLOR(toolbarBackground,     "#ffffff")

    DECLARE_QML_SINGLE_COLOR(sgTheme,              "#01F2B0")
    DECLARE_QML_SINGLE_COLOR(sgBackground,         "#102827")
    DECLARE_QML_SINGLE_COLOR(sgButton,             "#d0d0d0")
    DECLARE_QML_SINGLE_COLOR(sgLessTheme,          "#02DF82")
    DECLARE_QML_SINGLE_COLOR(sgToolbarBackground,  "#222222")
    DECLARE_QML_SINGLE_COLOR(ssHighlight,          "#F5DEB3")
    DECLARE_QML_SINGLE_COLOR(sgBorder,             "#66FFD1A4")

    DECLARE_QML_SINGLE_COLOR(brandingPurple,      "#4A2C6D")
    DECLARE_QML_SINGLE_COLOR(brandingBlue,        "#6045c5")
    DECLARE_QML_SINGLE_COLOR(toolStripFGColor,    "#ffffff")

    // Colors not affecting by theming or enable/disable
    DECLARE_QML_SINGLE_COLOR(mapWidgetBorderLight,          "#ffffff")
    DECLARE_QML_SINGLE_COLOR(mapWidgetBorderDark,           "#000000")
    DECLARE_QML_SINGLE_COLOR(mapMissionTrajectory,          "#be781c")
    DECLARE_QML_SINGLE_COLOR(surveyPolygonInterior,         "green")
    DECLARE_QML_SINGLE_COLOR(surveyPolygonTerrainCollision, "red" )
}

void QmlPalette::_signalPaletteChangeToAll()
{
    // Notify all objects of the new theme
    foreach (QmlPalette* palette, _paletteObjects) {
        palette->_signalPaletteChanged();
    }
}

void QmlPalette::_signalPaletteChanged()
{
    emit paletteChanged();
}
