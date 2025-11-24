import QtQuick
import QtQuick.Controls
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

    /*MyModel {
        id: myModel
        onCountChanged: {
            for (var i = 0; i < myModel.count; i++) {
                let surface = myModel.at(i)

                console.log("count:", myModel.count, "i:", i)

                switch(myModel.count) {
                case 1:
                    surface.toplevel.sendResizing(Qt.size(win.width, win.height))
                    console.log("Hello1")
                    break;
                case 2:
                    surface.toplevel.sendResizing(Qt.size(win.width / 2, win.height))
                    console.log("Hello2")
                    break;
                default:
                    switch (i) {
                        case 0:
                            surface.toplevel.sendResizing(Qt.size(view.width, view.height))
                            break;
                        default:
                            surface.toplevel.sendResizing(Qt.size(view.width, view.height / (myModel.count - 1)))
                            break;
                    }
                    console.log("Hello3")
                    break;
                }
            }
            view.forceLayout()
        }
    }*/

    ListModel {
        id: myModel
        onCountChanged: {
            for (var i = 0; i < myModel.count; i++) {
                let surface = myModel.get(i)

                console.log("count:", myModel.count, "i:", i)

                if (myModel.count === 1) {
                     surface.shellSurface.toplevel.sendResizing(Qt.size(win.width, win.height))
                } else {
                    if (i === 0) {
                        surface.shellSurface.toplevel.sendResizing(Qt.size(win.width / 2, win.height))
                    } else {
                        surface.shellSurface.toplevel.sendResizing(Qt.size(win.width / 2, win.height / (myModel.count - 1)))
                    }
                }
            }
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
            Shortcut {
                sequence: "F12"
                onActivated: {
                    console.log("F12 pressed - launching terminal")
                    launcher.launchTermunal(compositor.socketName)
                }
            }

            Shortcut {
                sequence: "F1"
                onActivated: {
                    console.log("F1 pressed - closing window")
                    win.close()
                }
            }

            Item {
                id: rootArea
                anchors.fill: parent
                Repeater {
                    model: myModel
                    ShellSurfaceItem {
                        id: shellSurfaceItem
                        shellSurface: model.shellSurface
                        onSurfaceDestroyed: myModel.remove(index)
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                myModel.forceActiveFocus()
                            }
                        }

                        property int count: myModel.count
                        property int idx: index

                        property real screenW: output.geometry.width
                        property real screenH: output.geometry.height

                        x: {
                            if (count === 1) return 0;
                            if (idx === 0) return 0;
                            return screenW / 2;
                        }

                        y: {
                            if (count === 1) return 0;
                            if (idx === 0) return 0;

                            // Высота одного окна в стеке
                            var stackHeight = screenH / (count - 1);
                            // Смещение (индекс в стеке * высоту)
                            // idx - 1, так как 0-й элемент это мастер
                            return (idx - 1) * stackHeight;
                        }

                        width: {
                            if (count === 1) return screenW;
                            return screenW / 2;
                        }

                        // Логика Высоты
                        // Одно окно -> вся высота
                        // Мастер (0-й) -> вся высота
                        // Остальные -> высота / (количество - 1)
                        height: {
                            if (count === 1) return screenH;
                            if (idx === 0) return screenH;
                            return screenH / (count - 1);
                        }

                        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        Behavior on y { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                    }
                }
            }
        }

        }
    
    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
                               myModel.append({ "shellSurface": xdgSurface });
                           }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }


}
