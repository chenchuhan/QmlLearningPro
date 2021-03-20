import QtQuick 2.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property alias asynchronous:        image.asynchronous
    property alias cache:               image.cache
    property alias fillMode:            image.fillMode
    property alias horizontalAlignment: image.horizontalAlignment
    property alias mirror:              image.mirror
    property alias paintedHeight:       image.paintedHeight
    property alias paintedWidth:        image.paintedWidth
    property alias progress:            image.progress
    property alias smooth:              image.smooth
    property alias mipmap:              image.mipmap
    property alias source:              image.source
    property alias sourceSize:          image.sourceSize
    property alias status:              image.status
    property alias verticalAlignment:   image.verticalAlignment
    property alias imageOpacity:        image.opacity;
    property alias sourceSizeHeight:    image.sourceSize.height
    property alias sourceSizeWidth:     image.sourceSize.width

    property alias coVisible:           co.visible
    property alias color:               co.color


    width:  image.width
    height: image.height

    Image {
        id:                 image
        smooth:             true
        mipmap:             true
        antialiasing:       true
        visible:            true
        fillMode:           Image.PreserveAspectFit
        anchors.fill:       parent
        sourceSize.height:  height
    }

    ColorOverlay {
        id:                 co;
        visible:            true;
        anchors.fill:       image
        source:             image
        color:              parent.color
    }
}
