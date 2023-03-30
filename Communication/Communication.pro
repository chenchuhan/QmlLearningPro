QT += quick \
        qml \
        network \
        quickcontrols2 \
        quickwidgets \
        svg \
        widgets \
        xml \
        serialport \
        core-private

#  testlib is needed even in release flavor for QSignalSpy support
QT += testlib
ReleaseBuild {
    # We don't need the testlib console in release mode
    QT.testlib.CONFIG -= console
}

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

INCLUDEPATH += \
    src \
    src/Communication \
    src/Communication/QmlFile \
    src/QmlGeneral \
    src/QmlControls \
    core

SOURCES += \
        core/UserApplication.cc \
        main.cpp \
        src/Communication/LinkConfiguration.cc \
        src/Communication/LinkInterface.cc \
        src/Communication/LinkManager.cc \
        src/Communication/TCPLink.cc \
        src/Communication/UDPLink.cc \
        src/Communication/UdpIODevice.cc \
        src/QmlGeneral/QmlObjectListModel.cc \
        src/QmlGeneral/QmlPalette.cc

RESOURCES += \
    $$PWD/Communication.qrc \
    qgcimages.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD \
                   $$PWD/src/Communication \
                   $$PWD/src/Communication/QmlFile \
                   $$PWD/src/QmlControls


# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    core/UserApplication.h \
    src/Communication/LinkConfiguration.h \
    src/Communication/LinkInterface.h \
    src/Communication/LinkManager.h \
    src/Communication/TCPLink.h \
    src/Communication/UDPLink.h \
    src/Communication/UdpIODevice.h \
    src/QmlGeneral/QmlObjectListModel.h \
    src/QmlGeneral/QmlPalette.h
