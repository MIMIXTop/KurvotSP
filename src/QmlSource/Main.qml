import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0

WaylandCompositor {
    id: compositor

    socketName: "wayland-1"

    Component.onCompleted: {
        console.log("WaylandCompositor initialized with socket:", socketName);
    }

    ListModel {
        id: myModel
        onCountChanged: {
            for (var i = 0; i < myModel.count; i++) {
                let surface = myModel.get(i);

                console.log("count:", myModel.count, "i:", i);

                if (myModel.count === 1) {
                    surface.shellSurface.toplevel.sendResizing(Qt.size(output.window.width, output.window.height));
                } else {
                    if (i === 0) {
                        surface.shellSurface.toplevel.sendResizing(Qt.size(output.window.width / 2, output.window.height));
                    } else {
                        surface.shellSurface.toplevel.sendResizing(Qt.size(output.window.width / 2, output.window.height / (myModel.count - 1)));
                    }
                }
            }
        }
    }

    CompositorScreen {
        id: output
        compositor: compositor
    }

    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
            myModel.append({
                "shellSurface": xdgSurface
            });
        }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    TextInputManager {}
    QtTextInputMethodManager {}
}
