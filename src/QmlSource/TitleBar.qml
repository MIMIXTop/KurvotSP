import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0
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

    Rectangle {
        id: powerButtonContainer
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 40
        radius: 20
        color: "black"
        border {
            color: "white"
            width: 3
        }

        Image {
            id: powerOffOnButton
            source: "qrc:/src/Resource/48.png"
            anchors.centerIn: parent
            width: 48
            height: 48
            fillMode: Image.PreserveAspectFit
            opacity: mouseArea.containsMouse ? 1.0 : 0.7

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                console.log("Shutdown button clicked!");
            }
        }
    }
}
