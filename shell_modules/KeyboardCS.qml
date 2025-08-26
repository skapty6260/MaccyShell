// import qs
// import qs.services
// import qs.modules.common
// import qs.modules.shared

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    Loader {
        id: kbchLoader
        active: false

        sourceComponent: PanelWindow {
            id: kbchRoot
            visible: kbchLoader.active

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            function hide() {
                kbchLoader.active = false;
            }

            exclusiveZone: 0
            implicitWidth: kbchBackground.width + Appearance.sizes.elevationMargin * 2
            implicitHeight: kbchBackground.height + Appearance.sizes.elevationMargin * 2
            WlrLayershell.namespace: "quickshell:kbcheatsheet"
            color: "transparent"

            mask: Region {
                item: kbchBackground
            }

            HyprlandFocusGrab { // Click outside to close
                id: grab
                windows: [kbchRoot]
                active: kbchRoot.visible
                onCleared: () => {
                    if (!active)
                        kbchRoot.hide();
                }
            }

            // Background
            // StyledRectangularShadow {
            //     target: kbchBackground
            // }
            Rectangle {
                id: kbchBackground
                anchors.centerIn: parent
                color: Appearance.colors.colLayer0
                border.width: 1
                border.color: Appearance.colors.colLayer0Border
                radius: Appearance.rounding.windowRounding
                property real padding: 30
                implicitWidth: kbchColumnLayout.implicitWidth + padding * 2
                implicitHeight: kbchColumnLayout.implicitHeight + padding * 2
            
                // RippleButton { // Close button
                //     id: closeButton
                //     focus: kbchRoot.visible
                //     implicitWidth: 40
                //     implicitHeight: 40
                //     buttonRadius: Appearance.rounding.full
                //     anchors {
                //         top: parent.top
                //         right: parent.right
                //         topMargin: 20
                //         rightMargin: 20
                //     }

                //     onClicked: {
                //         kbchRoot.hide();
                //     }

                //     contentItem: MaterialSymbol {
                //         anchors.centerIn: parent
                //         horizontalAlignment: Text.AlignHCenter
                //         font.pixelSize: Appearance.font.pixelSize.title
                //         text: "close"
                //     }
                // }

                ColumnLayout { // Content
                    id: kbchColumnLayout
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        text: "Keyboard Cheatsheet"
                        color: "#fff"
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "kbcheatsheet"

        function toggle(): void {
            cheatsheetLoader.active = !cheatsheetLoader.active;
        }

        function close(): void {
            cheatsheetLoader.active = false;
        }

        function open(): void {
            cheatsheetLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "kb_cheatsheetToggle"
        description: "Toggles keyboard cheatsheet on press"

        onPressed: {
            kbchLoader.active = !kbchLoader.active;
        }
    }

    GlobalShortcut {
        name: "kb_cheatsheetOpen"
        description: "Opens keyboard cheatsheet on press"

        onPressed: {
            kbchLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "kb_cheatsheetClose"
        description: "Closes keyboard cheatsheet on press"

        onPressed: {
            kbchLoader.active = false;
        }
    }
}