import QtQuick
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0

WaylandCompositor {
    id: compositor

    socketName: "wayland-1"
    Launcher {
        id: launcher
    }

    Component.onCompleted: {
        console.log("WaylandCompositor initialized with socket:", socketName)
    }

    MyModel {
        id: myModel
        onCountChanged: view.forceLayout()
    }

    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win

            property int pixelWidth: width * screen.devicePixelRatio
            property int pixelHeight: height * screen.devicePixelRatio

            visible: true
            width: 1920
            height: 1280

            Component.onCompleted: {
                console.log("Main window created with size:", width,
                            "x", height)
            }

            Background {
                anchors.fill: parent
            }

            // ![toplevels repeater]
            Item {
                anchors.fill: parent

                Row {
                    anchors.fill: parent
                    spacing: 5
                    ShellSurfaceItem {
                        shellSurface: myModel.at(0)
                        width: (myModel.count === 1) ? parent.width : (parent.width / 2)
                        height: parent.height
                        Component.onCompleted: {
                            console.log("HELLO")
                        }
                    }

                    ListView {
                        id: view
                        width: (myModel.count === 1) ? 0 : (parent.width / 2)
                        height: parent.height
                        model: myModel.allButFirst
                        anchors.top: parent.top
                        spacing: 5
                        delegate: ShellSurfaceItem {
                            shellSurface: modelData
                            width: parent.width
                            height: view.height / (myModel.count - 1)
                        }
                    }
                }
            }

            Shortcut {
                sequence: "F12"
                onActivated: {
                    console.log("F12 pressed - launching terminal")
                    launcher.launchTermunal(socketName)
                }
            }

            Shortcut {
                sequence: "F1"
                onActivated: {
                    console.log("F1 pressed - closing window")
                    win.close()
                }
            }
        }
    }

    // ![XdgShell]
    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
                               myModel.append(xdgSurface)
                               //toplevel.sendFullscreen(Qt.size(win.pixelWidth,
                               //                                win.pixelHeight))
                           }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    // ![XdgShell]
}
