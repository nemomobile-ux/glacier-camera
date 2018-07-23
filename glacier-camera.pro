TEMPLATE = app
TARGET = glacier-camera

QT += qml quick

CONFIG += link_pkgconfig
PKGCONFIG += glacierapp
LIBS += -lglacierapp

SOURCES += main.cpp

target.path = /usr/bin

qml.files = qml/*
qml.path = /usr/share/glacier-camera/qml

images.files = images/*
images.path = /usr/share/glacier-camera/images/

desktop.files = glacier-camera.desktop
desktop.path = /usr/share/applications

INSTALLS += target desktop qml images

DISTFILES += \
    rpm/glacier-camera.spec \
    qml/components.qml \
    qml/glacier-camera.qml \
    qml/components/ClickIcon.qml \
    qml/pages/CameraPage.qml \
    qml/pages/PreviewPage.qml \
    qml/pages/SettingsPage.qml

HEADERS +=
