import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0

WaylandOutput {
    id: output

    property bool isNestedCompositor: Qt.platform.pluginName.startsWith("wayland") || Qt.platform.pluginName === "xcb"

    property ListModel shellSurfaces: ListModel {}
    function handleShellSurface(shellSurface) {
        shellSurfaces.append({
            "shellSurface": shellSurface
        });
    }

    sizeFollowsWindow: output.isNestedCompositor

    Launcher {
        id: launcher
    }

    window: Window {
        id: win
        visible: true
        width: 1920
        height: 1280

        property int pixelWidth: width * screen.devicePixelRatio
        property int pixelHeight: height * screen.devicePixelRatio

        WaylandMouseTracker {
            id: mouseTracker
            anchors.fill: parent
            windowSystemCursorEnabled: output.isNestedCompositor

            Shortcut {
                sequence: "F12"
                onActivated: {
                    console.log("F12 pressed - launching terminal");
                    launcher.launchTermunal(output.compositor.socketName);
                }
            }

            Shortcut {
                sequence: "F1"
                onActivated: {
                    console.log("F1 pressed - closing window");
                    win.close();
                }
            }

            WaylandCursorItem {
                inputEventsEnabled: false
                x: mouseTracker.mouseX
                y: mouseTracker.mouseY
                seat: output.compositor.defaultSeat
            }

            TitleBar {
                id: titleBar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                color: "transparent"
            }

            Background {
                id: background
                anchors.fill: parent
                smooth: true
                source: "qrc:/src/Resource/background.jpg"
            }
        }
    }
}
