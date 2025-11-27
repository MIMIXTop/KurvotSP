import QtQuick
import QtQuick.Controls

Rectangle {
    id: rebootButtom

    Image {
        id: rebootButtomImg
        source: "qrc:/src/Resource/reboot-48.png"
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
            console.log("Reboot button clicked!");
        }
    }
}
