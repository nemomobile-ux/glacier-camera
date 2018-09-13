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

TRANSLATIONS += translations/glacier-camera_ru.ts

i18n_files.files = translations/*
i18n_files.path = /usr/share/$$TARGET/translations

INSTALLS += target desktop qml images i18n_files

DISTFILES += \
    rpm/glacier-camera.spec \
    qml/components.qml \
    qml/glacier-camera.qml \
    qml/components/ClickIcon.qml \
    qml/pages/CameraPage.qml \
    qml/pages/PreviewPage.qml \
    qml/pages/SettingsPage.qml \
    translations/*
