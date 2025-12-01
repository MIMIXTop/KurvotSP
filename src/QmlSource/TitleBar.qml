import QtQuick
import QtQuick.Controls
import Clock 1.0

Rectangle {
    id: titleBar

    Clock {
        id: clock
    }

    z: 1
    height: 40

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
