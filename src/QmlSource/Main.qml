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

                property int marginLeft: 12
                property int marginRight: 12
                property int marginTop: 12
                property int marginBottom: 12

                property int columnGap: 12     
                property int rowGap: 8       

                Repeater {
                    model: myModel
                    ShellSurfaceItem {
                        id: shellSurfaceItem
                        inputEventsEnabled: true
                        visible: modelData.toplevel.decrationMode === XdgDecorationManagerV1.ServerSideDecoration
                        shellSurface: model.shellSurface
                        onSurfaceDestroyed: myModel.remove(index)
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Activating window...1")
                                shellSurfaceItem.focus = true
                        }

                        property int count: myModel.count
                        property int idx: index

                        property real screenW: output.geometry.width
                        property real screenH: output.geometry.height

                        property real availW: screenW - (rootArea.marginLeft + rootArea.marginRight)
                        property real availH: screenH - (rootArea.marginTop + rootArea.marginBottom)

                        property real masterW: (count === 1)
                                            ? availW
                                            : (availW - rootArea.columnGap) / 2
                        property real stackW: masterW

                        property real stackItemH: {
                            if (count <= 1) return availH;
                            var n = count - 1;
                            var totalGaps = (n - 1) * rootArea.rowGap;
                            return (availH - totalGaps) / n;
                        }

                        Rectangle {
                            width: parent.width + 4
                            height: parent.height + 4
                            anchors.centerIn: parent
                            color: "transparent"
                            border.color: "steelblue"
                            border.width: 2
                            radius: 6
                            z: -1 // ниже окна
                        }

                        Rectangle {
                            id: windowFrame
                            anchors.fill: parent
                            radius: 8
                            color: "transparent" // или прозрачный, если нужно
                            clip: true      // обрезает содержимое по скруглению
                            z: 0
                        }

                        x: {
                            if (count === 1) return rootArea.marginLeft;
                            if (idx === 0) return rootArea.marginLeft;
                            return rootArea.marginLeft + masterW + rootArea.columnGap;
                        }

                        y: {
                            if (count === 1) return rootArea.marginTop;
                            if (idx === 0) return rootArea.marginTop; 
                            return rootArea.marginTop + (idx - 1) * (stackItemH + rootArea.rowGap);
                        }

                        width: {
                            if (count === 1) return masterW;
                            return (idx === 0) ? masterW : stackW;
                        }

                        height: {
                            if (count === 1) return availH;
                            if (idx === 0) return availH;    
                            return stackItemH;            
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
