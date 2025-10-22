// Copyright (C) 2018 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import QtQuick.Window
import QtQuick.Controls
import Launcher

WaylandCompositor {
    id: compositor

    socketName: "wayland-1"
    Launcher {
        id: launcher
    }

    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win

            property int pixelWidth: width * screen.devicePixelRatio
            property int pixelHeight: height * screen.devicePixelRatio

            visible: true
            width: 1280
            height: 720

            Image {
                anchors.fill: parent
                source: "file:///home/mimixtop/back.png"
                fillMode: Image.PreserveAspectCrop
            }

            Grid {
                id: grid

                property bool overview: true
                property int selected: 0
                property int selectedColumn: selected % columns
                property int selectedRow: selected / columns

                anchors.fill: parent
                columns: Math.ceil(Math.sqrt(toplevels.count))
                // ![zoom transform]
                transform: [
                    Scale {
                        xScale: grid.overview ? (1.0 / grid.columns) : 1
                        yScale: grid.overview ? (1.0 / grid.columns) : 1
                        Behavior on xScale {
                            PropertyAnimation {
                                easing.type: Easing.InOutQuad
                                duration: 200
                            }
                        }
                        Behavior on yScale {
                            PropertyAnimation {
                                easing.type: Easing.InOutQuad
                                duration: 200
                            }
                        }
                    },
                    Translate {
                        x: grid.overview ? 0 : win.width * -grid.selectedColumn
                        y: grid.overview ? 0 : win.height * -grid.selectedRow
                        Behavior on x {
                            PropertyAnimation {
                                easing.type: Easing.InOutQuad
                                duration: 200
                            }
                        }
                        Behavior on y {
                            PropertyAnimation {
                                easing.type: Easing.InOutQuad
                                duration: 200
                            }
                        }
                    }
                ]
                // ![zoom transform]

                // ![toplevels repeater]
                Repeater {
                    model: toplevels
                    Item {
                        width: win.width
                        height: win.height
                        ShellSurfaceItem {
                            anchors.fill: parent
                            shellSurface: xdgSurface
                            onSurfaceDestroyed: toplevels.remove(index)
                        }
                        MouseArea {
                            enabled: grid.overview
                            anchors.fill: parent
                            onClicked: {
                                grid.selected = index
                                grid.overview = false
                            }
                        }
                    }
                }
                // ![toplevels repeater]
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "Toggle overview"
                onClicked: grid.overview = !grid.overview
            }
            Shortcut {
                sequence: "F12"
                onActivated: launcher.qtLaunchtermunal(socketName)
            }

            Shortcut {
                sequence: "F1"
                onActivated: win.close()
            }

            Shortcut {
                sequence: "Super"
                onActivated: grid.overview = !grid.overview
            }

            // Image {
            //     id: backbraund
            //     anchors.fill: parent
            //     source: "/home/mimixtop/Projects/FutureKurvot/TemplateWaylandCompositor/build/Qt_6_10_0_PATH-Debug/backgraund.png"
            // }

            // Shortcut {
            //     sequence: "right"
            //     onActivated: grid.selected = Math.min(grid.selected + 1,
            //                                           toplevels.count - 1)
            // }
            // Shortcut {
            //     sequence: "left"
            //     onActivated: grid.selected = Math.max(grid.selected - 1, 0)
            // }
            // Shortcut {
            //     sequence: "up"
            //     onActivated: grid.selected = Math.max(
            //                      grid.selected - grid.columns, 0)
            // }
            // Shortcut {
            //     sequence: "down"
            //     onActivated: grid.selected = Math.min(
            //                      grid.selected + grid.columns,
            //                      toplevels.count - 1)
            // }
        }
    }

    ListModel {
        id: toplevels
    }

    // ![XdgShell]
    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
                               toplevels.append({
                                                    "xdgSurface": xdgSurface
                                                })
                               toplevel.sendFullscreen(Qt.size(win.pixelWidth,
                                                               win.pixelHeight))
                           }
    }
    // ![XdgShell]
}
