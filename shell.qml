//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import QtCore
import Qt.labs.folderlistmodel

import qs.services

ShellRoot {
    id: shellRoot

    property var disabledModules: [""]
    property var activeModules: []
    property int reloadTrigger: 0

    Component.onCompleted: {
        // Force start singletons
    }

    FolderListModel {
        id: folderModel
        folder: Qt.resolvedUrl("./shell_modules")
        nameFilters: ["*.qml"]
        showDirs: false
    }

    Instantiator {
        id: moduleInstantiator
        model: reloadTrigger >= 0 && folderModel

        delegate: Loader {
            required property string fileName
            active: reloadTrigger >= 0 && !disabledModules.includes(fileName)
            source: "./shell_modules/"+fileName
        }
    }

    IpcHandler {
        target: "modules"

        function logDisabled(): void {
            console.log("Disabled: ", JSON.stringify(disabledModules))
        }

        function disableModule(module: string): void {
            if (disabledModules.includes(module)) {
                console.log("Module already disabled.")
                return;
            }
            disabledModules.push(module);
            reloadModules();
        }

        function enableModule(module: string): void {
            var index = disabledModules.indexOf(module);
            if (index !== -1) {
                disabledModules.splice(index, 1);
                reloadModules();
            } else {
                console.log("Module is not disabled.");
            }
        }

        function reloadModules(): void {
            console.log("Reloading modules...");            
            for (var i = 0; i < activeModules.length; i++) {
                if (activeModules[i] && activeModules[i].destroy) {
                    activeModules[i].destroy();
                }
            }
            activeModules = [];
            reloadTrigger++;
            console.log("Modules reloaded");
        }
    }
}