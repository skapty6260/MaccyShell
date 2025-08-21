pragma Singleton

import Quickshell
import QtQuick
import Quickshell
import QtQuick.Controls
import Qt.labs.settings

Singleton {
    id: root

    // Base paths
    property string xdgDataHome: Qt.application.environment()["XDG_DATA_HOME"] || Qt.application.homePath() + "/.local/share"
    property string configHome: Qt.application.environment()["XDG_CONFIG_HOME"] || Qt.application.homePath() + "/.config"
    property string kvantumConfigPath: configHome + "/Kvantum/kvantum.kvconfig"
    property string gtkSettingsPath: configHome + "/gtk-3.0/settings.ini"
    property string defaultKvantumConfigPath: "/usr/share/Kvantum/kvantum.kvconfig"
    property string defaultIconTheme: "Adwaita"

    // Theme properties with defaults
    property color windowBackground: styleHelper.windowBackground
    property color windowForeground: styleHelper.windowForeground
    property color highlightColor: styleHelper.highlight
    property color buttonBackground: styleHelper.buttonBackground
    property color buttonForeground: styleHelper.buttonForeground

    property string fontFamily: styleHelper.fontFamily || systemSettings.font
    property int fontSize: styleHelper.fontSize || systemSettings.fontSize
    property string iconTheme: styleHelper.iconTheme

    Settings {
        id: systemSettings
        category: "Theme"
        property string font: "Sans"
        property int fontSize: 10
    }

    // Style helper that reads system themes
    QtObject {
        id: styleHelper

        function getGtkTheme() {
            try {
                var gtkTheme = Qt.application.queryGtkTheme()
                if (gtkTheme) return gtkTheme

                var env = Qt.application.environment()
                return env.GTK_THEME || "Adwaita"
            } catch (e) {
                console.warn("Failed to read GTK theme:", e)
                return "Fusion"
            }
        }

        readonly property string gtkTheme: getGtkTheme()
        readonly property color windowBackground: readKvantumValue('windowColor', 'red')
        readonly property color windowForeground: "black"
        readonly property color highlightColor: "#3daee9"
        readonly property color buttonBackground: Qt.rgba(0.85, 0.85, 0.85, 1)
        readonly property color buttonForeground: "black"

        readonly property string fontFamily: {
            var font = Qt.application.queryFont("font")
            return font ? font.family : "Sans"
        }

        readonly property int fontSize: {
            var size = Qt.application.queryFont("font")
            return size ? size.pixelSize : 10
        }

        readonly property string iconTheme: {
            return Qt.application.queryIconTheme() || "Adwaita"
        }
    }

    function kvantumConfigPath() {
        var paths = [
            kvantumConfigPath,
            gtkSettingsPath,
            defaultKvantumConfigPath
        ]
        
        for (var i = 0; i < paths.length; i++) {
            if (Qt.exists(paths[i])) return paths[i]
        }
        return ""
    }

    // Reads a single value from Kvantum config
    function readKvantumValue(key, defaultValue) {
        var path = kvantumConfigPath()
        if (!path) return defaultValue
        
        try {
            var file = Qt.openUrl(path)
            var contents = file.readAll()
            file.close()
            
            var lines = contents.split('\n')
            for (var i = 0; i < lines.length; i++) {
                if (lines[i].startsWith(key + "=")) {
                    return lines[i].split('=')[1].trim()
                }
            }
        } catch (e) {
            console.warn("Error reading Kvantum config:", e)
        }
        return defaultValue
    }

    // Updates all theme properties based on current system state
    function updateTheme() {
        var kvantumTheme = readKvantumValue("theme", "Default")
        var gtkTheme = styleHelper.getGtkTheme()
        var iconTheme = styleHelper.iconTheme
        var font = styleHelper.fontFamily
        var fontSize = styleHelper.fontSize

        root.windowBackground = styleHelper.windowBackground
        root.windowForeground = styleHelper.windowForeground
        root.highlightColor = styleHelper.highlightColor
        root.buttonBackground = styleHelper.buttonBackground
        root.buttonForeground = styleHelper.buttonForeground
        root.fontFamily = font
        root.fontSize = fontSize
        root.iconTheme = iconTheme

        ApplicationWindow.styleHints.colorScheme = 
            windowBackground.lightness > 0.7 ? Qt.Light : Qt.Dark

        console.log("Theme updated:",
            "\n  GTK Theme:", gtkTheme,
            "\n  Kvantum Theme:", kvantumTheme,
            "\n  Icon Theme:", iconTheme,
            "\n  Font:", font + " " + fontSize + "pt"
        )
    }

    // Initialize
    Component.onCompleted: {
        updateTheme()
        console.log("CURRENT WINDOW BG COLOR: ")
        
        // Set up theme change monitoring
        var watcher = Qt.createQmlObject(`
            import QtCore
            QtObject {
                property var fileSystemWatcher: FileSystemWatcher {
                    id: watcher
                    paths: [
                        gtkSettingsPath,
                        configHome + "/Kvantum/"
                    ]
                    onFileChanged: root.updateTheme()
                    onDirectoryChanged: root.updateTheme()
                }
            }`, root, "themeWatcher")
    }

    // Function to load icons based on the selected icon theme
    function loadIcon(iconName, size) {
        var iconPath = `${xdgDataHome}/icons/${iconTheme}/${size}x${size}/${iconName}.png`;
        if (Qt.exists(iconPath)) {
            return iconPath;
        }
        // Fallback to default icon if not found
        return `${xdgDataHome}/icons/${defaultIconTheme}/${size}x${size}/${iconName}.png`;
    }
}