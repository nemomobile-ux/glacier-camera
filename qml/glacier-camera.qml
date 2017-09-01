import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0

import "pages"

ApplicationWindow {
    id: root

    property int cameraId: 0
    property string fileName: ""

    //contentOrientation: Screen.orientation

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            if (pageStack.depth > 1) {
                pageStack.pop();
                event.accepted = true;
            } else { Qt.quit(); }
        }
    }

    initialPage: CameraPage{}
}
