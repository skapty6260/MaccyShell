pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.utils
import Qt.labs.platform
import QtQuick
import Quickshell

Singleton {
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]

    property string assetsPath: Quickshell.shellPath("assets")
    property string generatedThemePath: FileUtils.trimFileProtocol(`${Directories.state}/user/generated/colors.json`)
    property string themesPath: FileUtils.trimFileProtocol(`${Directories.shellConfigDir}/themes`)
    property string shellConfigDir: FileUtils.trimFileProtocol(`${Directories.config}/maccy-shell`)
    property string shellConfigPath: `${Directories.shellConfigDir}/config.json`

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", `${shellConfigDir}`])
        Quickshell.execDetached(["mkdir", "-p", `${themesPath}`])
    }
}