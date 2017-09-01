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
        title: "Camera"
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
                Qt.quit()
            }
        }

        onLockStatusChanged: {
            if(lockStatus == Camera.Locked)
            {
                camera.imageCapture.captureToLocation("/home/nemo/Pictures/camera_"+Qt.formatDateTime(new Date(),"yyMMdd_hhmmss")+".jpg")
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
    }

    Label{
        id: zoomLabel
        text: "X "+pincharea.zoomValue.toFixed(1)
        color: "white"
        font.pixelSize: 75
        anchors.centerIn: parent

        visible: false
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
            if(cameraId+1 == QtMultimedia.availableCameras.length)
            {
                cameraId = 0;

            }
            else
            {
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
        anchors{
            bottom: parent.bottom
            bottomMargin: width/2
            horizontalCenter: parent.horizontalCenter
        }
        onClicked: {
            camera.searchAndLock();
        }
    }
}
