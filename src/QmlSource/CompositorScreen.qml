import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import ConfigManager 1.0

WaylandOutput {
    id: output

    property bool isNestedCompositor: Qt.platform.pluginName.startsWith("wayland") || Qt.platform.pluginName === "xcb"

    property ListModel shellSurfaces: ListModel {}
    function handleShellSurface(shellSurface) {
        shellSurfaces.append({
            "shellSurface": shellSurface
        });
    }

    signal requestCloseCurrentWindow

    property var windowModel

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

            ConfigManager {
                id: config
            }

            Shortcut {
                sequence: config.keyTerminal
                onActivated: {
                    console.log(config.keyTerminal + " pressed - launching terminal");
                    launcher.launchProgram(config.terminal, output.compositor.socketName);
                }
            }

            Shortcut {
                sequence: "F1" // Keep F1 as hardcoded fallback or add to config if needed, but user didn't ask for it specifically to be configurable yet, but let's stick to the plan. Wait, plan said "Suggestion: Add key_closeWindow". I added it to config. Let's use it.
                onActivated: {
                    console.log("F1 pressed - closing window");
                    win.close();
                }
            }

            Shortcut {
                sequence: config.keyCloseWindow
                onActivated: {
                    console.log(config.keyCloseWindow + " pressed - requesting close current window");
                    output.requestCloseCurrentWindow();
                }
            }

            Shortcut {
                sequence: config.keyWofi
                onActivated: {
                    launcher.launchProgram(config.wofi, output.compositor.socketName);
                    console.log(config.keyWofi + " pressed - launching wofi");
                }
            }

            Shortcut {
                sequence: config.keyFolderManager
                onActivated: {
                    launcher.launchProgram(config.folderManager, output.compositor.socketName);
                    console.log(config.keyFolderManager + " pressed - launching folder manager");
                }
            }

            Shortcut {
                sequence: config.keyBrowser
                onActivated: {
                    launcher.launchProgram(config.browser, output.compositor.socketName);
                    console.log(config.keyBrowser + " pressed - launching browser");
                }
            }

            Shortcut {
                sequence: config.keyCodeRedactor
                onActivated: {
                    launcher.launchProgram(config.codeRedactor, output.compositor.socketName);
                    console.log(config.keyCodeRedactor + " pressed - launching code redactor");
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
                windowModel: output.windowModel
                compositor: output.compositor
            }
        }
    }
}
