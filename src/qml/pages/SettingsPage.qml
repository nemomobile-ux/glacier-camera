/*
 * Copyright (C) 2021-2024 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

import QtQuick
import QtQuick.Controls

import Nemo
import Nemo.Controls

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
                iso = isoModel.get(isoRoller.currentIndex).name
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
