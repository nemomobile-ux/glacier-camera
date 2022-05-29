import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

NemoIcon  {
    id: clickIcon

    signal clicked

    color: clickMouseArea.pressed ? Theme.accentColor : Theme.fillColor
    opacity: 0.6

    MouseArea{
        id: clickMouseArea
        anchors.fill: parent
        onClicked: {
            clickIcon.clicked()
        }
    }
}
