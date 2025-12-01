import QtQuick
import QtQuick.Controls
import Clock 1.0

Rectangle {
    id: titleBar

    signal requestOpenConfig

    Clock {
        id: clock
    }

    z: 1
    height: 40

    Rectangle {
        id: configButton
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        width: 100
        color: "black"
        radius: 20
        border {
            color: "white"
            width: 3
        }

        Text {
            anchors.centerIn: parent
            text: "Config"
            color: "white"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: titleBar.requestOpenConfig()
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 300
        height: 40
        color: "black"
        radius: 20
        border {
            color: "white"
            width: 3
        }
        Text {
            text: clock.time + " | " + clock.date
            font.pixelSize: 20
            anchors.centerIn: parent
            color: "white"
        }
    }

    ButtonsContainerBackground {
        id: buttonsContainerBackground
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
    }
}
