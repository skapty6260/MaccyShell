//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

// Adjust this to make the app smaller or larger
//@ pragma Env QT_SCALE_FACTOR=1
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell

import qs.modules.common

ApplicationWindow {
    id: root

    property var pages: [
        {
            name: "Hyprland",
            icon: "hyprland",
            component: "../modules/settings/HyprlandConfig.qml"
        },
        {
            name: "Style",
            icon: "palette",
            component: "../modules/settings/StyleConfig.qml"
        }
    ]
    property int currentPage: 0
    property real contentPadding: 8

    visible: true
    onClosing: Qt.quit()
    title: "MaccyShell Settings"

    width: 1100
    height: 750
    color: Appearance.ms_colors.ms_background

    ColumnLayout {
        anchors {
            fill: parent
            margins: contentPadding
        }

        Text {
            text: "Settings"
            color: "black"
        }
    }
}