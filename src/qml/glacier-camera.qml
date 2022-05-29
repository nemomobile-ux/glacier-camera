import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0

import org.nemomobile.settings 1.0

import "pages"

ApplicationWindow {
    id: root

    property int cameraId: 0
    property string fileName: ""

    property string iso: "auto";

    Settings{
        id: settings;
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            if (pageStack.depth > 1) {
                pageStack.pop();
                event.accepted = true;
            } else { Qt.quit(); }
        }
    }

    initialPage: CameraPage{}

    onFileNameChanged: {
        settings.setValue("lastFile",fileName);
    }

    onCameraIdChanged: {
        settings.setValue("cameraId",cameraId);
    }

    Component.onCompleted: {
        cameraId = settings.value("cameraId",0)
        fileName = settings.value("lastFile","")
        iso = settings.value("iso","auto");
    }
}
