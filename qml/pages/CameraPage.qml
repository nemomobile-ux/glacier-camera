import QtQuick 2.6
import QtMultimedia 5.5

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0

import "../components"

Page {
    id: cameraPage

    headerTools: HeaderToolsLayout {
        id: tools
        title: qsTr("Camera")
        tools: [
            ToolButton {
                iconSource: "/usr/share/glacier-camera/images/gear.svg"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("/usr/share/glacier-camera/qml/pages/SettingsPage.qml"));
                }
            }
        ]
    }

    Camera {
        id: camera
        deviceId: QtMultimedia.availableCameras[cameraId].deviceId;

        captureMode: Camera.CaptureViewfinder

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        imageCapture {
            onImageSaved: {
                lastPhoto.source = fileName
            }
        }

        onLockStatusChanged: {
            if(lockStatus == Camera.Locked) {
                fileName = "/home/nemo/Pictures/camera_"+Qt.formatDateTime(new Date(),"yyMMdd_hhmmss")+".jpg";
                camera.imageCapture.captureToLocation(fileName)
            }
        }

        focus {
            focusMode: Camera.FocusAuto
            focusPointMode: Camera.FocusPointCustom
        }

        Component.onCompleted: {
            if(root.iso === "auto") {
                exposure.setAutoIsoSensitivity()
            } else {
                exposure.manualIso = root.iso;
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        color: "black";

        VideoOutput {
            id: viewFinder
            source: camera
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
            anchors.fill: parent
            onClicked: {
                var point_x = mouse.x / Screen.width
                var point_y = mouse.y / Screen.height
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
        color: "white"
        font.pixelSize: 75
        anchors.centerIn: parent

        visible: false
    }

    Image{
        id: lastPhoto
        source: settings.value("lastFile","")
        width: getShot.width/3*2
        height: width

        anchors{
            left: getShot.right
            leftMargin: width
            verticalCenter: getShot.verticalCenter
        }

        visible: fileName != ""
        fillMode: Image.PreserveAspectCrop

        MouseArea{
            anchors.fill: parent
            onClicked: {
                pageStack.push(Qt.resolvedUrl("/usr/share/glacier-camera/qml/pages/PreviewPage.qml"));
            }
        }
    }

    ClickIcon{
        id: cameraChange

        width: getShot.width/3*2
        height: width
        source: "/usr/share/glacier-camera/images/refresh.svg"
        anchors{
            right: getShot.left
            rightMargin: width
            verticalCenter: getShot.verticalCenter
        }

        visible: QtMultimedia.availableCameras.length > 1;

        onClicked: {
            camera.stop();
            if(cameraId+1 == QtMultimedia.availableCameras.length) {
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
        source: "/usr/share/glacier-camera/images/camera.svg"
        anchors {
            bottom: parent.bottom
            bottomMargin: width/2
            horizontalCenter: parent.horizontalCenter
        }
        onClicked: {
            camera.searchAndLock();
        }
    }

    Rectangle{
        id: focusPoint
        width: getShot.width/3
        height: width

        radius: width/2

        color: "#0091e5"
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
}
