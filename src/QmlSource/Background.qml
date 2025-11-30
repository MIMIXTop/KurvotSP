import QtQuick
import QtQuick.Controls
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Launcher 1.0
import MyModel 1.0
import Clock 1.0

import ConfigManager 1.0

Rectangle {
    id: background
    color: config.backgroundColor

    ConfigManager {
        id: config
    }

    Image {
        anchors.fill: parent
        source: config.backgroundImage
        fillMode: Image.PreserveAspectCrop
        visible: config.backgroundImage !== ""
    }

    property int marginLeft: config.windowSpacing
    property int marginRight: config.windowSpacing
    property int marginTop: 40
    property int marginBottom: config.windowSpacing

    property int columnGap: config.windowSpacing
    property int rowGap: config.windowSpacing

    property var windowModel
    property var compositor
    Repeater {
        model: windowModel
        Chrome {
            id: appContainer
            shellSurface: model.shellSurface
            layoutConfig: background
            onRequestActivate: {
                console.log("=== Window Click (BEFORE focus) ===");
                console.log("Clicked window index:", index);
                console.log("===================================");

                windowModel.activate(index);
                background.activateSurface(model.shellSurface);
            }
        }
    }

    function activateSurface(targetSurface) {
        for (var i = 0; i < windowModel.count; ++i) {
            var item = windowModel.at(i);
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
