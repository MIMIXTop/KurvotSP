import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0

WaylandCompositor {
    id: compositor

    socketName: "wayland-1"

    Component.onCompleted: {
        console.log("WaylandCompositor initialized with socket:", socketName);
    }

    property WaylandSurface windowFocus: null

    MyModel {
        id: myModel
        onCountChanged: {
            for (var i = 0; i < myModel.count; i++) {
                let surface = myModel.at(i);

                console.log("count:", myModel.count, "i:", i);

                if (myModel.count === 1) {
                    surface.toplevel.sendResizing(Qt.size(output.window.width, output.window.height));
                } else {
                    if (i === 0) {
                        surface.toplevel.sendResizing(Qt.size(output.window.width / 2, output.window.height));
                    } else {
                        surface.toplevel.sendResizing(Qt.size(output.window.width / 2, output.window.height / (myModel.count - 1)));
                    }
                }
            }
        }

        /*onRequestActivate: surface => {
            console.log("Switching focus to new surface");
            if (surface && surface.surface) {
                compositor.defaultSeat.keyboardFocus = surface.surface;
            }
        }*/
    }

    CompositorScreen {
        id: output
        compositor: compositor
    }

    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
            myModel.append(xdgSurface);
        }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    TextInputManager {}
    QtTextInputMethodManager {}
}
