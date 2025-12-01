import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWayland.Compositor
import QtWayland.Compositor.QtShell

import ConfigManager 1.0

QtShellChrome {
    id: chrome

    ConfigManager {
        id: config
    }

    property alias shellSurface: shellSurfaceItemId.shellSurface
    property var layoutConfig

    property int count: myModel.count
    property int idx: index

    property real screenW: win.width
    property real screenH: win.height

    property real availW: screenW - (layoutConfig.marginLeft + layoutConfig.marginRight)
    property real availH: screenH - (layoutConfig.marginTop + layoutConfig.marginBottom)

    property real masterW: (count === 1) ? availW : (availW - layoutConfig.columnGap) / 2
    property real stackW: masterW

    property real stackItemH: {
        if (count <= 1)
            return availH;
        var n = count - 1;
        if (n === 1)
            return availH;
        return (availH - (n - 1) * layoutConfig.rowGap) / n;
    }

    signal requestActivate

    Component.onCompleted: {
        requestActivate();
        console.log("Chrome: Component completed");
        console.log("Chrome: shellSurface", shellSurface);
        console.log("Chrome: shellSurface.toplevel", shellSurface.toplevel);
        console.log("Chrome: shellSurface.toplevel.activated", shellSurface.toplevel.activated);
    }

    readonly property bool isWindowActive: shellSurface && shellSurface.toplevel && shellSurface.toplevel.activated
    readonly property color activeColor: config.focusColor
    readonly property color inactiveColor: "gray"
    readonly property color borderColor: isWindowActive ? activeColor : inactiveColor

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: mouse => {
            console.log("MouseArea in Chrome PRESSED!");
            requestActivate();
            mouse.accepted = false;
        }
        z: -1
    }

    Rectangle {
        id: windowBackground
        anchors.fill: parent
        color: "transparent"
        radius: 8
        z: -1

        Rectangle {
            id: contentArea
            anchors.fill: parent
            anchors.margins: 10 - config.borderSize
            color: borderColor
            radius: 4
        }
    }

    Rectangle {
        id: leftResizeHandle
        width: 10
        color: "transparent"
        border.color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: rightResizeHandle
        width: 10
        color: "transparent"
        border.color: "transparent"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: topResizeHandle
        height: 10
        color: "transparent"
        border.color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
    }

    Rectangle {
        id: bottomResizeHandle
        height: 10
        color: "transparent"
        border.color: "transparent"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    Rectangle {
        id: topLeftResizeHandle
        height: 10
        width: 10
        color: "transparent"
        border.color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
    }

    Rectangle {
        id: topRightResizeHandle
        height: 10
        width: 10
        color: "transparent"
        border.color: "transparent"
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Rectangle {
        id: bottomLeftResizeHandle
        height: 10
        width: 10
        color: "transparent"
        border.color: "transparent"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: bottomRightResizeHandle
        height: 10
        width: 10
        color: "transparent"
        border.color: "transparent"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    leftResizeHandle: leftResizeHandle
    rightResizeHandle: rightResizeHandle
    topResizeHandle: topResizeHandle
    bottomResizeHandle: bottomResizeHandle
    topLeftResizeHandle: topLeftResizeHandle
    topRightResizeHandle: topRightResizeHandle
    bottomLeftResizeHandle: bottomLeftResizeHandle
    bottomRightResizeHandle: bottomRightResizeHandle

    x: {
        if (count === 1)
            return layoutConfig.marginLeft;
        if (idx === 0)
            return layoutConfig.marginLeft;
        return layoutConfig.marginLeft + masterW + layoutConfig.columnGap;
    }

    y: {
        if (count === 1)
            return layoutConfig.marginTop;
        if (idx === 0)
            return layoutConfig.marginTop;
        return layoutConfig.marginTop + (idx - 1) * (stackItemH + layoutConfig.rowGap);
    }

    width: {
        if (count === 1)
            return masterW;
        return (idx === 0) ? masterW : stackW;
    }

    height: {
        if (count === 1)
            return availH;
        if (idx === 0)
            return availH;
        return stackItemH;
    }

    Item {
        id: contentContainer
        anchors.top: topResizeHandle.bottom
        anchors.left: leftResizeHandle.right
        anchors.bottom: bottomResizeHandle.top
        anchors.right: rightResizeHandle.left
        anchors.topMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.rightMargin: 0

        ShellSurfaceItem {
            id: shellSurfaceItemId
            anchors.fill: parent

            moveItem: chrome
            focus: true

            staysOnBottom: shellSurface && (shellSurface.windowFlags & Qt.WindowStaysOnBottomHint)
            staysOnTop: !staysOnBottom && shellSurface && (shellSurface.windowFlags & Qt.WindowStaysOnTopHint)

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onPressed: mouse => {
                    console.log("ShellSurfaceItem MouseArea PRESSED!");
                    requestActivate();
                    mouse.accepted = false;
                }
            }
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    Behavior on y {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }
}
