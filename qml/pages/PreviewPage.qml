import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0


Page {
    id: previewPage

    headerTools: HeaderToolsLayout {
        id: tools
        title: qsTr("Preview")
        showBackButton: true;
    }

    Item{
        width: parent.width
        height: parent.height

        Image{
            width: parent.width
            height: parent.height
            source: fileName
            fillMode: Image.PreserveAspectCrop
        }
    }
}
