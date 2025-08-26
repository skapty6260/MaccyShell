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
import Quickshell.Hyprland
import QtQuick.Effects
import Quickshell

import qs.modules.common
import qs.modules.common.widgets

ApplicationWindow {
    id: root
    HyprlandWindow.opacity: 0.2

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
    minimumWidth: 800
    minimumHeight: 600

    width: 1100
    height: 750
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#000"
            opacity: 0.5
        }

        // Titlebar
        Item {
            visible: Config.options?.windows.showTitlebar
            Layout.fillWidth: true
            Layout.fillHeight: false
            implicitHeight: Math.max(titleText.implicitHeight, windowControlsRow.implicitHeight)

            StyledText {
                id: titleText
                anchors {
                    left: Config.options.windows.centerTitle ? undefined : parent.left
                    horizontalCenter: Config.options.windows.centerTitle ? parent.horizontalCenter : undefined
                    verticalCenter: parent.verticalCenter
                    leftMargin: 12
                }
                color: "#fff"
                text: "Settings"
                font.pixelSize: Appearance.font.pixelSize.title
                font.family: Appearance.font.family.title
            }
            
            RowLayout { // Window controls row
                id: windowControlsRow
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                RippleButton {
                    buttonRadius: Appearance.rounding.full
                    implicitWidth: 35
                    implicitHeight: 35
                    onClicked: root.close()
                    contentItem: MaterialSymbol {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        text: "close"
                        iconSize: 20
                    }
                }
            }
        }

        // Row layout for sidebar navigation and overall content
    }
}