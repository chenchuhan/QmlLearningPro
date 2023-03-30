import QtQuick                  2.12
import QtQuick.Controls         2.12

import QmlControls   1.0

Text {
    property bool _min: false
    property bool _small: false
    property bool _large: false
    property bool _big:   false
    property bool _huge:   false

    color:          "white"
    antialiasing:   true
    font.bold:      true
    font.pixelSize: getPixel()

    function getPixel() {
        ///从小到大的
        if(_min) {
            return ScreenTools.minText
        }
        else if(_small) {
            return ScreenTools.smallText
        }
        else if(_big) {
            return ScreenTools.bigText
        }
        else if(_large) {
            return ScreenTools.largeText
        }
        else if(_huge) {
            return ScreenTools.hugeText
        }
        else {
            return ScreenTools.mediumText
        }
    }
}
