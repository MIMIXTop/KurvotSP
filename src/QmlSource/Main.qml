import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0
import ConfigManager 1.0

WaylandCompositor {
    id: compositor

    socketName: "wayland-1"

    Component.onCompleted: {
        console.log("WaylandCompositor initialized with socket:", socketName);
    }

    ConfigManager {
        id: config
    }

    property WaylandSurface windowFocus: null
    property variant primarySurfacesArea: null
    property int windowCount: 0
    property int lastActiveIndex: -1

    MyModel {
        id: myModel
        function updateLayout() {
            console.log("--- Window Statistics ---");
            console.log("Total windows:", myModel.count);
            var focusedSurface = compositor.defaultSeat.keyboardFocus;
            var focusFound = false;

            for (var j = 0; j < myModel.count; j++) {
                if (myModel.at(j).surface === focusedSurface) {
                    focusFound = true;
                    break;
                }
            }

            if (!focusFound && myModel.count > 0) {
                let lastSurface = myModel.at(myModel.count - 1);
                if (lastSurface && lastSurface.surface) {
                    compositor.defaultSeat.keyboardFocus = lastSurface.surface;
                    focusedSurface = lastSurface.surface;
                    console.log("Focus transferred to last window:", lastSurface);
                }
            }

            for (var i = 0; i < myModel.count; i++) {
                let surface = myModel.at(i);
                let isFocused = (surface.surface === focusedSurface);
                console.log(`Window ${i}: ${surface} - Focused: ${isFocused}`);

                let states = isFocused ? [XdgToplevel.Activated] : [];

                if (myModel.count === 1) {
                    surface.toplevel.sendConfigure(Qt.size(output.window.width, output.window.height), states);
                } else {
                    if (i === 0) {
                        surface.toplevel.sendConfigure(Qt.size(output.window.width / 2, output.window.height), states);
                    } else {
                        surface.toplevel.sendConfigure(Qt.size(output.window.width / 2, output.window.height / (myModel.count - 1)), states);
                    }
                }
            }
            console.log("-------------------------");
        }

        onCountChanged: updateLayout()
        onLayoutUpdated: updateLayout()

        onRequestActivate: (surface, index) => {
            console.log("Switching focus to new surface, index:", index);
            if (surface && surface.surface) {
                compositor.defaultSeat.keyboardFocus = surface.surface;
                lastActiveIndex = index;
                console.log("lastActiveIndex set to:", lastActiveIndex);

                console.log("\n=== Window Click Statistics (AFTER focus set) ===");
                console.log("Activated window index:", index);
                console.log("Activated window object:", surface);

                console.log("\nAll windows:");
                for (var i = 0; i < myModel.count; i++) {
                    let item = myModel.at(i);
                    let isFocused = (item.surface === compositor.defaultSeat.keyboardFocus);
                    console.log("  Window", i + ":", item, "- Focused:", isFocused);
                }

                console.log("\nActivated window details:");
                if (surface) {
                    console.log("  Surface:", surface.surface);
                    if (surface.toplevel) {
                        console.log("  Toplevel:", surface.toplevel);
                        console.log("  Toplevel.activated:", surface.toplevel.activated);
                    }
                }

                console.log("\nCurrent keyboard focus:", compositor.defaultSeat.keyboardFocus);
                console.log("Focus matches activated window:", (surface.surface === compositor.defaultSeat.keyboardFocus));
                console.log("=================================================\n");
            }
        }
    }

    CompositorScreen {
        id: output
        compositor: compositor
        windowModel: myModel
        onRequestCloseCurrentWindow: {
            console.log("=== Closing Window ===");
            console.log("All windows before close:");
            for (var i = 0; i < myModel.count; i++) {
                let item = myModel.at(i);
                console.log("  Window", i + ":", item, "- Focused:", (item.surface === compositor.defaultSeat.keyboardFocus));
            }

            if (lastActiveIndex >= 0 && lastActiveIndex < myModel.count) {
                let itemToClose = myModel.at(lastActiveIndex);
                console.log("Removing window at lastActiveIndex:", lastActiveIndex);
                console.log("Window to close:", itemToClose);
                console.log("Window to close - Focused:", (itemToClose.surface === compositor.defaultSeat.keyboardFocus));

                if (itemToClose && itemToClose.toplevel) {
                    itemToClose.toplevel.sendClose();
                }
            } else {
                console.log("No valid lastActiveIndex:", lastActiveIndex);
            }
            console.log("======================");
        }
    }

    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
            if (myModel.count >= config.maxWindows) {
                console.log("Max windows reached (" + config.maxWindows + "), closing new window");
                toplevel.sendClose();
                // Alternatively, if sendClose() isn't immediate or sufficient for a just-created surface:
                // xdgSurface.destroy();
                return;
            }

            myModel.append(xdgSurface);

            if (myModel.count === 1) {
                console.log("Auto-activating first window");
                myModel.activate(0);
            }
        }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    TextInputManager {}
    QtTextInputMethodManager {}
}
