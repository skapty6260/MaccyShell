pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: Directories.shellConfigPath
    property var options: configOptionsJsonAdapter
    property bool ready: false

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.options;
        let parents = [obj];

        // Traverse and collect parent objects
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        // Convert value to correct type using JSON.parse when safe
        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        obj[keys[keys.length - 1]] = convertedValue;
    }

    FileView {
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: configOptionsJsonAdapter

            property JsonObject windows: JsonObject {
                property bool showTitlebar: true
                property bool centerTitle: true
            }

            property JsonObject appearance: JsonObject {
                // Настройка спейсингов и общих переменных: paddings, margins, roundings
                // Настройка прозрачности элементов шела
                // Настройка цветовой палитры
                property string selectedTheme: 'glassmorph'
                property string accentScheme: 'dark' // dark || light
            }

            property JsonObject hacks: JsonObject {
                property int arbitraryRaceConditionDelay: 300
            }

            property JsonObject background: JsonObject {
                property string wallpaperPath: ""
                property string thumbnailPath: ""
                property JsonObject parallax: JsonObject {
                    property bool vertical: false
                    property bool enableWorkspace: true
                    property real workspaceZoom: 1.07 // Relative to your screen, not wallpaper size
                    property bool enableSidebar: true
                }
                property string mantra: ""
                property bool hideWhenFullscreen: true
            }
        }
    }
}