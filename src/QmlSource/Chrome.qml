import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWayland.Compositor
import QtWayland.Compositor.QtShell

QtShellChrome {
    id: chrome

    property alias shellSurface: shellSurfaceItemId.shellSurface
    property var layoutConfig

    property int count: myModel.count
    property int idx: index
    
    property real screenW: win.width
    property real screenH: win.height
    
    property real availW: screenW - (layoutConfig.marginLeft + layoutConfig.marginRight)
    property real availH: screenH - (layoutConfig.marginTop + layoutConfig.marginBottom)
    
    property real masterW: (count === 1)
                           ? availW
                           : availW / 2
    property real stackW: masterW
    
    property real stackItemH: {
        if (count <= 1) return availH;
        var n = count - 1;
        return availH / n;
    }

    //! [leftResizeHandle]
    Rectangle {
        id: leftResizeHandle
        color: "gray"
        width: visible ? 5 : 0
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
    //! [leftResizeHandle]

    Rectangle {
        id: rightResizeHandle
        color: "gray"
        width: visible ? 5 : 0
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: topResizeHandle
        color: "gray"
        height: visible ? 5 : 0
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
    }

    Rectangle {
        id: bottomResizeHandle
        color: "gray"
        height: visible ? 5 : 0
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    Rectangle {
        id: topLeftResizeHandle
        color: "gray"
        height: 5
        width: 5
        anchors.left: parent.left
        anchors.top: parent.top
    }

    Rectangle {
        id: topRightResizeHandle
        color: "gray"
        height: 5
        width: 5
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Rectangle {
        id: bottomLeftResizeHandle
        color: "gray"
        height: 5
        width: 5
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }


    Rectangle {
        id: bottomRightResizeHandle
        color: "gray"
        height: 5
        width: 5
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    leftResizeHandle: leftResizeHandle
    rightResizeHandle: rightResizeHandle
    topResizeHandle: topResizeHandle
    bottomResizeHandle: bottomResizeHandle
    topLeftResizeHandle:  topLeftResizeHandle
    topRightResizeHandle: topRightResizeHandle
    bottomLeftResizeHandle: bottomLeftResizeHandle
    bottomRightResizeHandle: bottomRightResizeHandle

    x: {
        if (count === 1) return layoutConfig.marginLeft;
        if (idx === 0) return layoutConfig.marginLeft;
        return layoutConfig.marginLeft + masterW;
    }

    y: {
        if (count === 1) return layoutConfig.marginTop;
        if (idx === 0) return layoutConfig.marginTop;
        return layoutConfig.marginTop + (idx - 1) * stackItemH;
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

    ShellSurfaceItem {
        id: shellSurfaceItemId
        anchors.top: topResizeHandle.bottom
        anchors.left: leftResizeHandle.right
        anchors.bottom: bottomResizeHandle.top
        anchors.right: rightResizeHandle.left


        moveItem: chrome

        staysOnBottom: shellSurface && (shellSurface.windowFlags & Qt.WindowStaysOnBottomHint)
        staysOnTop: !staysOnBottom && shellSurface && (shellSurface.windowFlags & Qt.WindowStaysOnTopHint)
    }

    Behavior on x { 
        NumberAnimation { 
            duration: 300; 
            easing.type: Easing.OutQuad 
        } 
    }
    Behavior on y { 
        NumberAnimation { 
            duration: 300; 
            easing.type: Easing.OutQuad 
        } 
    }
    Behavior on width { 
        NumberAnimation { 
            duration: 300; 
            easing.type: Easing.OutQuad 
        } 
    }
    Behavior on height { 
        NumberAnimation { 
            duration: 300; 
            easing.type: Easing.OutQuad 
        } 
    }
}
