import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0


Page {
    id: settingsPage

    headerTools: HeaderToolsLayout {
        id: tools
        title: qsTr("Settings")
        showBackButton: true;
    }

    Column {
        width: parent.width
        anchors{
            top: parent.top
            topMargin: 40
        }

        ListModel{
            id: isoModel
            ListElement { name: "Auto"}
            ListElement { name: "100" }
            ListElement { name: "200" }
            ListElement { name: "400" }
        }

        GlacierRoller {
            id: isoRoller
            width: parent.width

            clip: true
            model: isoModel
            label: qsTr("ISO")
            delegate: GlacierRollerItem{
                Text {
                    height: isoRoller.itemHeight
                    text: name
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: (isoRoller.activated && isoRoller.currentIndex === index)
                }
            }
            onCurrentIndexChanged:{
                settings.setValue("iso",isoModel.get(isoRoller.currentIndex).name);
                root.iso = isoModel.get(isoRoller.currentIndex).name
            }
        }
    }

    Component.onCompleted: {
        isoRoller.currentIndex = getIndexByName(isoModel,settings.value("iso","auto"))
    }


    function getIndexByName(model,name){
        for(var i = 0; i < model.count; i++) {
            if(model.get(i).name === name) {
                return i;
            }
        }
        return 0;
    }
}
