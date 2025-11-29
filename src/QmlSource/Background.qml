import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0
import Clock 1.0

Image {
    id: background

    property int marginLeft: 0
    property int marginRight: 0
    property int marginTop: 40
    property int marginBottom: 0

    property int columnGap: 0
    property int rowGap: 0

    //fillMode: Image.Tile
    Repeater {
        model: myModel
        Chrome {
            id: appContainer
            shellSurface: model.shellSurface
            layoutConfig: background
            /*onRequestActivate: {
                myModel.activate(index);
                background.activateSurface(model.shellSurface);
            }*/
        }
    }

    function activateSurface(targetSurface) {
        for (var i = 0; i < myModel.count; ++i) {
            var item = myModel.at(i);
            var surface = item;
            if (surface && surface.toplevel) {
                if (surface === targetSurface) {
                    surface.toplevel.sendConfigure(Qt.size(0, 0), [XdgToplevel.Activated]);
                } else {
                    surface.toplevel.sendConfigure(Qt.size(0, 0), []);
                }
            }
        }
    }
}
