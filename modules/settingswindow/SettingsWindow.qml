pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.modules.settingswindow.sidebar

Singleton {
    id: root

    function create() {
        system_settings.createObject(dummy);
    }

    QtObject {
        id: dummy
    }

    Component {
        id: system_settings

        FloatingWindow {
            id: win
            HyprlandWindow.opacity: 0.85
            visible: true
            width: 640
            height: 480
            minimumSize.width: 1000
            minimumSize.height: 720

            title: qsTr("Settings")

            onVisibleChanged: {
                if (!visible)
                    destroy();
            }

            property string currentPage: "Displays"

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Sidebar {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                Loader {
                    id: pageLoader
                    anchors.fill: parent
                    source: "./" + win.currentPage + ".qml"
                }
            }

            function close(): void {
                win.destroy();
            }
        }
    }
}