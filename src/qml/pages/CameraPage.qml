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

import QtMultimedia
import QtSensors

import "../components"

Page {
    id: cameraPage

    headerTools: HeaderToolsLayout {
        id: tools
        title: qsTr("Camera")
        tools: [
            ToolButton {
                iconSource: "image://theme/gear";
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("qrc:///pages/SettingsPage.qml"));
                }
            }
        ]
    }


    function writeMetaData() {
        captureView.captureOrientation = orientationSensor.rotationAngle
        camera.metaData.date = new Date()
    }

    Camera {
        id: camera
        cameraDevice: QtMultimedia.availableCameras[cameraId].deviceId;

        //captureMode: Camera.CaptureStillImage

        whiteBalanceMode: Camera.WhiteBalanceAuto

        exposureCompensation: -1.0
        exposureMode: Camera.ExposurePortrait

        /*onLockStatusChanged: {
            if(lockStatus == Camera.Locked) {
                fileName = imageDir+"/camera_"+Qt.formatDateTime(new Date(),"yyMMdd_hhmmss")+".jpg";
                camera.imageCapture.captureToLocation(fileName)
            }
            console.log("lockStatusChanged: " + lockStatus)
        }*/

        focusMode: Camera.FocusContinuous
        flashMode: Camera.FlashAuto

        Component.onCompleted: {
            if(iso === "auto") {
                exposure.setAutoIsoSensitivity()
            } else {
                exposure.manualIso = iso;
            }
        }

        onErrorChanged: {
            console.error("Camera error: "  + camera.errorCode + " " + camera.errorString)
        }
    }

    Rectangle{
        anchors.fill: parent
        color: Theme.backgroundColor

        VideoOutput {
            id: viewFinder
            //source: camera
            width: parent.width
            height: parent.height
            fillMode: VideoOutput.PreserveAspectFit
            clip: true
            focus : visible // to receive focus and capture key events when visible
        }
    }

    PinchArea{
        id: pincharea
        anchors.fill: parent
        pinch.target: viewFinder

        pinch.minimumScale: 1
        pinch.maximumScale: 4.0

        property  real zoomValue: 0
        property double oldZoom: 0

        onPinchStarted: {
            oldZoom = pincharea.scale
            zoomLabel.visible = true
        }

        onPinchUpdated: {
            if(zoomValue < 4.0) {
                zoomValue = oldZoom + pinch.scale
            }
        }
        onPinchFinished: {
            zoomValue = oldZoom + pinch.scale
            if(zoomValue < 4.0) {
                camera.setDigitalZoom(zoomValue)
            }
            zoomLabel.visible = false
        }

        MouseArea {
            id: focusArea
            anchors.fill: parent
            onClicked: {
                var point_x = mouse.x / root.width
                var point_y = mouse.y / root.height
                camera.focus.customFocusPoint = Qt.point(point_x, point_y)
                focusPoint.x = mouse.x-focusPoint.radius
                focusPoint.y = mouse.y-focusPoint.radius
                focusPoint.visible = true;
            }
        }
    }

    Label{
        id: zoomLabel
        text: "X "+pincharea.zoomValue.toFixed(1)
        color: Theme.textColor
        font.pixelSize: Theme.fontSizeExtraLarge
        anchors.centerIn: parent

        visible: false
    }

    Image{
        id: lastPhoto
        source: "file://" + fileName
        width: getShot.width/3*2
        height: width

        anchors{
            left: getShot.right
            leftMargin: width
            verticalCenter: getShot.verticalCenter
        }

        visible: fileName !== ""

        fillMode: Image.PreserveAspectCrop

        MouseArea{
            anchors.fill: parent
            onClicked: {
                pageStack.push(Qt.resolvedUrl("qrc:///pages/PreviewPage.qml"));
            }
        }
    }

    ClickIcon{
        id: cameraChange

        width: getShot.width/3*2
        height: width
        source: "image://theme/refresh"
        anchors{
            right: getShot.left
            rightMargin: width
            verticalCenter: getShot.verticalCenter
        }

        visible: QtMultimedia.availableCameras.length > 1;

        onClicked: {
            camera.stop();
            if(cameraId+1 >= QtMultimedia.availableCameras.length) {
                cameraId = 0;
            } else {
                cameraId++;
            }
            camera.start();
        }
    }

    ClickIcon{
        id: getShot
        width: cameraPage.height/10
        height: width
        source: "image://theme/camera"
        anchors {
            bottom: parent.bottom
            bottomMargin: width/2
            horizontalCenter: parent.horizontalCenter
        }
        onClicked: {
//            console.log("supported focus modes: " + focus.supportedFocusModes
//                                          + ", FocusManual: " + CameraFocus.FocusManual
//                                          + ", FocusHyperfocal: " + CameraFocus.FocusHyperfocal
//                                          + ", FocusInfinity: " + CameraFocus.FocusInfinity
//                                          + ", FocusAuto: " + CameraFocus.FocusAuto
//                                          + ", FocusContinuous: " + CameraFocus.FocusContinuous
//                                          + ", FocusMacro: " + CameraFocus.FocusMacro
//                                          )

            if (focus.supportedFocusModes === undefined) {
                console.warn("no focus mode available. Taking picture without focusing")
                fileName = imageDir+"/camera_"+Qt.formatDateTime(new Date(),"yyMMdd_hhmmss")+".jpg";
                camera.imageCapture.captureToLocation(fileName)
                return;
            }

            if (camera.lockStatus === Camera.Unlocked) {
                camera.searchAndLock();
            } else {
                camera.unlock();
            }
        }
    }

    Rectangle{
        id: focusPoint
        width: getShot.width/3
        height: width

        radius: width/2

        color: Theme.accentColor
        visible: false

        onVisibleChanged: {
            if(visible === true) {
                opacity = 1
                focusAnimation.start()
            }
        }
    }
    SequentialAnimation {
        id: focusAnimation
        NumberAnimation {
            target: focusPoint
            property: "opacity"
            duration: 500
            to: 0
        }
        PropertyAction {
            target: focusPoint
            property: "visible"
            value: false
        }
    }

    OrientationSensor {
        id: orientationSensor
        active: true

        property int rotationAngle: reading && reading.orientation ? getOrientation(reading.orientation) : 0
        function getOrientation(value) {
            switch (value) {
            case 1:
                return 0
            case 2:
                return 180
            case 3:
                return 270
            default:
                return 90
            }
        }
    }

}
