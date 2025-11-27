import QtQuick
import QtQuick.Controls

Rectangle {
    id: buttonsContainerBackground
    color: "black"
    radius: 20
    height: 48
    width: 112

    border {
        width: 3
        color: "white"
    }

    Row {
        id: buttonsContainer
        anchors.centerIn: parent
        spacing: 8

        RebootButtom {
            id: rebootButtom
            width: 40
            height: 40
            color: "transparent"
        }

        ShotdownButton {
            id: powerButtonContainer
            width: 40
            height: 40
            color: "transparent"
        }
    }
}
