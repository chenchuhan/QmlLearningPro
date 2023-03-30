/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#ifndef QmlPalette_h
#define QmlPalette_h

#include <QObject>
#include <QColor>
#include <QMap>


//start_cch_20230326
#define DECLARE_QML_SINGLE_COLOR(name, color) \
    { \
        _colorInfoMap[QStringLiteral(#name)] = QColor(color); \
        _colors << #name; \
    }

#define DEFINE_QML_COLOR(NAME, SETNAME) \
    Q_PROPERTY(QColor NAME READ NAME WRITE SETNAME NOTIFY paletteChanged) \
    QColor NAME() const { return _colorInfoMap[QStringLiteral(#NAME)]; } \
    void SETNAME(const QColor& color) { _colorInfoMap[QStringLiteral(#NAME)] = color; _signalPaletteChangeToAll(); }


/*!
 QmlPalette is used in QML ui to expose color properties for the QGC palette. There are two
 separate palettes in QGC, light and dark. The light palette is for outdoor use and the dark
 palette is for indoor use. Each palette also has a set of different colors for enabled and
 disabled states.

 Usage:

        import QGroundControl.Palette 1.0

        Rectangle {
            anchors.fill:   parent
            color:          qgcPal.window

            QmlPalette { id: qgcPal: colorGroupEnabled: enabled }
        }
*/

class QmlPalette : public QObject
{
    Q_OBJECT

public:

    Q_PROPERTY(QStringList  colors              READ colors             CONSTANT)

    DEFINE_QML_COLOR(window,                        setWindow)
    DEFINE_QML_COLOR(windowShadeLight,              setWindowShadeLight)
    DEFINE_QML_COLOR(windowShade,                   setWindowShade)
    DEFINE_QML_COLOR(windowShadeDark,               setWindowShadeDark)
    DEFINE_QML_COLOR(text,                          setText)
    DEFINE_QML_COLOR(warningText,                   setWarningText)
    DEFINE_QML_COLOR(button,                        setButton)
    DEFINE_QML_COLOR(buttonText,                    setButtonText)
    DEFINE_QML_COLOR(buttonHighlight,               setButtonHighlight)
    DEFINE_QML_COLOR(buttonHighlightText,           setButtonHighlightText)
    DEFINE_QML_COLOR(primaryButton,                 setPrimaryButton)
    DEFINE_QML_COLOR(primaryButtonText,             setPrimaryButtonText)
    DEFINE_QML_COLOR(textField,                     setTextField)
    DEFINE_QML_COLOR(textFieldText,                 setTextFieldText)
    DEFINE_QML_COLOR(mapButton,                     setMapButton)
    DEFINE_QML_COLOR(mapButtonHighlight,            setMapButtonHighlight)
    DEFINE_QML_COLOR(mapIndicator,                  setMapIndicator)
    DEFINE_QML_COLOR(mapIndicatorChild,             setMapIndicatorChild)
    DEFINE_QML_COLOR(mapWidgetBorderLight,          setMapWidgetBorderLight)
    DEFINE_QML_COLOR(mapWidgetBorderDark,           setMapWidgetBorderDark)
    DEFINE_QML_COLOR(mapMissionTrajectory,          setMapMissionTrajectory)
    DEFINE_QML_COLOR(brandingPurple,                setBrandingPurple)
    DEFINE_QML_COLOR(brandingBlue,                  setBrandingBlue)
    DEFINE_QML_COLOR(colorGreen,                    setColorGreen)
    DEFINE_QML_COLOR(colorOrange,                   setColorOrange)
    DEFINE_QML_COLOR(colorRed,                      setColorRed)
    DEFINE_QML_COLOR(colorGrey,                     setColorGrey)
    DEFINE_QML_COLOR(colorBlue,                     setColorBlue)
    DEFINE_QML_COLOR(alertBackground,               setAlertBackground)
    DEFINE_QML_COLOR(alertBorder,                   setAlertBorder)
    DEFINE_QML_COLOR(alertText,                     setAlertText)
    DEFINE_QML_COLOR(missionItemEditor,             setMissionItemEditor)
    DEFINE_QML_COLOR(statusFailedText,              setstatusFailedText)
    DEFINE_QML_COLOR(statusPassedText,              setstatusPassedText)
    DEFINE_QML_COLOR(statusPendingText,             setstatusPendingText)
    DEFINE_QML_COLOR(surveyPolygonInterior,         setSurveyPolygonInterior)
    DEFINE_QML_COLOR(surveyPolygonTerrainCollision, setSurveyPolygonTerrainCollision)
    DEFINE_QML_COLOR(toolbarBackground,             setToolbarBackground)
    DEFINE_QML_COLOR(toolStripFGColor,              setToolStripFGColor)
    DEFINE_QML_COLOR(toolStripHoverColor,           setToolStripHoverColor)
    //start_cch_20210720 +3
    DEFINE_QML_COLOR(sgTheme,                       setSgTheme)
    DEFINE_QML_COLOR(sgBackground,                  setSgBackground)
    DEFINE_QML_COLOR(sgButton,                      setSgButton)
    DEFINE_QML_COLOR(sgLessTheme,                   setSgLessTheme)
    DEFINE_QML_COLOR(sgToolbarBackground,           setSgToolbarBackground)
    DEFINE_QML_COLOR(ssHighlight,                   setSsHighlight)
    DEFINE_QML_COLOR(sgBorder,                      setSgBorder)

     QmlPalette(QObject* parent = nullptr);
    ~QmlPalette();

    QStringList colors                      () const { return _colors; }
    void        setColorGroupEnabled        (bool enabled);


signals:
    void paletteChanged ();

private:
    static void _buildMap                   ();
    static void _signalPaletteChangeToAll   ();
    void        _signalPaletteChanged       ();
    void        _themeChanged               ();

    static QStringList          _colors;

//    static QMap<int, QMap<int, QMap<QString, QColor>>> _colorInfoMap;   // theme -> colorGroup -> color name -> color
    static QMap<QString, QColor> QmlPalette::_colorInfoMap;               //color name -> color
    static QList<QmlPalette*> _paletteObjects;    ///< List of all active QmlPalette objects
};

#endif
