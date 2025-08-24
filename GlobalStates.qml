pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    // Включенные модули
    property var enabledModules: {children: []}

    // Props like screen lock toggled and others
    property real screenZoom: 1
    onScreenZoomChanged: {
        Quickshell.execDetached(["hyprctl", "keyword", "cursor:zoom_factor", root.screenZoom.toString()]);
    }
    Behavior on screenZoom {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    IpcHandler {
		target: "zoom"

		function zoomIn() {
            screenZoom = Math.min(screenZoom + 0.4, 3.0)
        }

        function zoomOut() {
            screenZoom = Math.max(screenZoom - 0.4, 1)
        } 
	}
}