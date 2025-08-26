pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/*
    ThemeLoader должен взять выбранную тему из конфига и прочитать все данные из файлика темы
    После прочтения должен заменить все properties в Appearance.qml

    Структура тем:
    ~/.config/maccy-shell/themes/${themeName}/${accentScheme (Dark or Light)}.json

    glassmorph dark path:
    ~/.config/maccy-shell/themes/glassmorph/dark.json
*/

Singleton {
    id: root

    property bool ready: false

    property string theme: Config.options.appearance.selectedTheme
    property string accentScheme: Config.options.appearance.accentScheme
    property string themeFilePath: `${Directories.themesPath}/${root.theme}/${root.accentScheme}.json`

    function reapplyTheme() {
        console.log(`Reapplying theme...\n\tTheme: ${themeFilePath}`)
        themeFileView.reload()
    }

    function applyConfig(fileContent) {
        const json = JSON.parse(fileContent)
        console.log(`\bTHEME CONFIG:\n${JSON.stringify(json)}`)
    
        applyUnnested(json['colors'], 'colors')
        applyUnnested(json['rounding'], 'rounding')
        applyNested(json['font'], 'font')
    }

    function applyUnnested(json, partKey) {
        for (const key in json) {
            console.log(`${partKey}: [${key}] - ${json[key]}`)
            Appearance[partKey][key] = json[key];
        }
    }

    // Only 2 nested layers and nesting is persisted
    function applyNested(json, partKey) {
        for (const nestKey in json) {
            for (const key in json[nestKey]) {
                Appearance[partKey][nestKey][key] = json[nestKey][key]
            }
        }
    }

    Timer {
        id: delayedFileRead
        interval: Config.options?.hacks?.arbitraryRaceConditionDelay ?? 100
        repeat: false
        running: false
        onTriggered: {
            root.applyColors(themeFileView.text())
        }
    }

    FileView {
        id: themeFileView
        path: Qt.resolvedUrl(root.themeFilePath)
        watchChanges: true
        onFileChanged: {
            this.reload()
            delayedFileRead.start()
        }
        onLoadedChanged: {
            const fileContent = themeFileView.text()
            root.applyConfig(fileContent)
        }
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.log("Selected theme not exists")
            }
        }
    }
}