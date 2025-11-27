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

            WaylandCursorItem {
                inputEventsEnabled: false
                x: mouseTracker.mouseX
                y: mouseTracker.mouseY
                seat: output.compositor.defaultSeat
            }

            Row {
                id: taskbar
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                Rectangle{
                    id: tt
                    color: "black"
                    anchors.fill: parent.fill
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
                        onRequestActivate: {
                            background.activateSurface(model.shellSurface)
                        }
                    }
                }

                function activateSurface(targetSurface) {
                    for (var i = 0; i < myModel.count; ++i) {
                        var item = myModel.get(i);
                        var surface = item.shellSurface;
                        if (surface && surface.toplevel) {
                             if (surface === targetSurface) {
                                 surface.toplevel.sendConfigure(Qt.size(0,0), [XdgToplevel.Activated]);
                             } else {
                                 surface.toplevel.sendConfigure(Qt.size(0,0), []);
                             }
                        }
                    }
                }
            }
        }
    }
}
