import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0

WaylandOutput {
    id: output

    property bool isNestedCompositor: Qt.platform.pluginName.startsWith(
                                          "wayland")
                                      || Qt.platform.pluginName === "xcb"

    //! [handleShellSurface]
    property ListModel shellSurfaces: ListModel {}
    function handleShellSurface(shellSurface) {
        shellSurfaces.append({
                                 "shellSurface": shellSurface
                             })
    }

    sizeFollowsWindow: output.isNestedCompositor

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
                    console.log("F12 pressed - launching terminal")
                    launcher.launchTermunal(output.compositor.socketName)
                }
            }

            Shortcut {
                sequence: "F1"
                onActivated: {
                    console.log("F1 pressed - closing window")
                    win.close()
                }
            }

            Image {
                id: background

                property int marginLeft: 0
                property int marginRight: 0
                property int marginTop: 0
                property int marginBottom: 0

                property int columnGap: 0
                property int rowGap: 0

                anchors.fill: parent
                fillMode: Image.Tile
                source: "qrc:/src/Resource/background.jpg"
                smooth: true

                Repeater {
                    model: myModel
                    Chrome {
                        id: appContainer
                        shellSurface: model.shellSurface
                        layoutConfig: background
                    }
                }
            }
        }
    }
}
