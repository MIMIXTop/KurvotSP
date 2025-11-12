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
        onCountChanged: {
            for (var i = 0; i < myModel.count; ++i) {
                let surface = myModel.at(i) // получаем xdgSurface
                if (i === 0 && myModel.count > 1) {
                    // первый занимает половину экрана
                    surface.toplevel.sendFullscreen(
                                Qt.size(
                                    mainTail.width * screen.devicePixelRatio,
                                    mainTail.height * screen.devicePixelRatio))
                } else if (myModel.count > 1) {
                    // остальные делят вторую половину
                    surface.toplevel.sendFullscreen(
                                Qt.size(
                                    view.width * screen.devicePixelRatio,
                                    (view.height / (myModel.count - 1)) * screen.devicePixelRatio))
                } else {
                    // единственное окно занимает всё
                    surface.toplevel.sendFullscreen(Qt.size(win.pixelWidth,
                                                            win.pixelHeight))
                }
            }

            view.forceLayout()
        }
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
                height: parent.height
                width: parent.width

                Row {
                    anchors.fill: parent
                    height: parent.height
                    width: parent.width

                    ListView {
                        id: mainTail
                        width: (myModel.count === 1) ? parent.width : (parent.width / 2)
                        height: parent.height
                        model: myModel.first
                        delegate: ShellSurfaceItem {
                            shellSurface: modelData
                            width: mainTail.width
                            height: mainTail.height
                            focus: true
                        }
                    }

                    ListView {
                        id: view
                        width: (myModel.count === 1) ? 0 : (parent.width / 2)
                        height: parent.height
                        model: myModel.allButFirst
                        delegate: ShellSurfaceItem {
                            shellSurface: modelData
                            width: view.width
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
                               if (myModel.count > 1) {
                                   toplevel.sendFullscreen(
                                       Qt.size(
                                           view.width * screen.devicePixelRatio,
                                           (view.height / (myModel.count - 1))
                                           * screen.devicePixelRatio))
                               } else {

                                   toplevel.sendFullscreen(Qt.size(
                                                               win.pixelWidth,
                                                               win.pixelHeight))
                               }
                           }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    // ![XdgShell]
}
