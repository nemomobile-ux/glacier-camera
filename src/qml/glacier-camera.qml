/*
 * Copyright (C) 2021-2026 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.settings 1.0
import org.glacier.camera 1.0

import "pages"

ApplicationWindow {
    id: root

    property int cameraId: 0
    property string lastImage: ""

    property string iso: "auto";

    Settings{
        id: settings;
    }

    FileUtils{
        id: fileUtils
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

    onLastImageChanged: {
        settings.setValue("lastFile",lastImage);
    }

    onCameraIdChanged: {
        settings.setValue("cameraId",cameraId);
    }

    Component.onCompleted: {
        cameraId = settings.value("cameraId",0)
        lastImage = settings.value("lastFile","")
        if(!fileUtils.fileExists(lastImage)) {
            lastImage = "";
        }

        iso = settings.value("iso","auto");
    }
}
