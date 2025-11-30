import QtQuick
import QtQuick.Controls
import Launcher 1.0

Rectangle {
    id: powerButton

    Launcher {
        id: processManager
    }

    Image {
        id: powerOffOnButton
        source: "qrc:/src/Resource/shotdown-24.png"
        anchors.centerIn: parent
        width: 24
        height: 24
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
            processManager.shutdown();
        }
    }
}
