pragma ComponentBehavior: Bound

import qs
import qs.modules.common
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

Variants {
    id: root
    model: Quickshell.screens

    PanelWindow {
        id: bgRoot

        required property var modelData

        // Hide on fullscreen
        property list<HyprlandWorkspace> workspacesForMonitor: Hyprland.workspaces.values.filter(workspace=>workspace.monitor && workspace.monitor.name == monitor.name)
        property var activeWorkspaceWithFullscreen: workspacesForMonitor.filter(workspace=>((workspace.toplevels.values.filter(window=>window.wayland.fullscreen)[0] != undefined) && workspace.active))[0]
        visible: (!(activeWorkspaceWithFullscreen != undefined)) || !Config?.options.background.hideWhenFullscreen //GlobalStates.screenLocked || (before all)

        // Workspaces
        property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
        property list<var> relevantWindows: HyprlandData.windowList.filter(win => win.monitor == monitor?.id && win.workspace.id >= 0).sort((a, b) => a.workspace.id - b.workspace.id)
        property int firstWorkspaceId: relevantWindows[0]?.workspace.id || 1
        property int lastWorkspaceId: relevantWindows[relevantWindows.length - 1]?.workspace.id || 10

        // Wallpaper props
        // TODO: clean code version with property of video exts
        property bool wallpaperIsVideo: Config.options.background.wallpaperPath.endsWith(".mp4") || Config.options.background.wallpaperPath.endsWith(".webm") || Config.options.background.wallpaperPath.endsWith(".mkv") || Config.options.background.wallpaperPath.endsWith(".avi") || Config.options.background.wallpaperPath.endsWith(".mov")
        property string wallpaperPath: wallpaperIsVideo ? Config.options.background.thumbnailPath : Config.options.background.wallpaperPath
        property real wallpaperToScreenRatio: Math.min(wallpaperWidth / screen.width, wallpaperHeight / screen.height)
        property real preferredWallpaperScale: Config.options.background.parallax.workspaceZoom
        property real effectiveWallpaperScale: 1 // Some reasonable init value, to be updated
        property int wallpaperWidth: modelData.width // Some reasonable init value, to be updated
        property int wallpaperHeight: modelData.height // Some reasonable init value, to be updated

        // Colors
        // ...

        // Layer props
        screen: modelData
        exclusionMode: ExclusionMode.ignore
        WlrLayershell.layer: WlrLayer.Bottom //GlobalStates.screenLocked ? WlrLayer.Overlay : WlrLayer.Bottom
        WlrLayershell.namespace: "quickshell:background"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent" 

        // Wallpaper
        Image {
            id: wallpaper
            visible: opacity > 0
            opacity: (status === Image.Ready && !bgRoot.wallpaperIsVideo) ? 1 : 0
            Behavior on opacity {
                animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
            }
            cache: false
            asynchronous: true
            retainWhileLoading: true
            // Range = groups that workspaces span on
            property int chunkSize: Config?.options.bar.workspaces.shown ?? 10;
            property int lower: Math.floor(bgRoot.firstWorkspaceId / chunkSize) * chunkSize;
            property int upper: Math.ceil(bgRoot.lastWorkspaceId / chunkSize) * chunkSize;
            property int range: upper - lower;
            property real valueX: {
                let result = 0.5;
                if (Config.options.background.parallax.enableWorkspace && !Config.options.background.parallax.vertical) {
                    result = ((bgRoot.monitor.activeWorkspace?.id - lower) / range);
                }
                if (Config.options.background.parallax.enableSidebar) {
                    result += (0.15 * GlobalStates.sidebarRightOpen - 0.15 * GlobalStates.sidebarLeftOpen);
                }
                return result;
            }
            property real valueY: {
                let result = 0.5;
                if (Config.options.background.parallax.enableWorkspace && Config.options.background.parallax.vertical) {
                    result = ((bgRoot.monitor.activeWorkspace?.id - lower) / range);
                }
                return result;
            }
            property real effectiveValueX: Math.max(0, Math.min(1, valueX))
            property real effectiveValueY: Math.max(0, Math.min(1, valueY))
            x: -(bgRoot.movableXSpace) - (effectiveValueX - 0.5) * 2 * bgRoot.movableXSpace
            y: -(bgRoot.movableYSpace) - (effectiveValueY - 0.5) * 2 * bgRoot.movableYSpace
            source: bgRoot.wallpaperPath
            fillMode: Image.PreserveAspectCrop
            Behavior on x {
                NumberAnimation {
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }
            sourceSize {
                width: bgRoot.screen.width * bgRoot.effectiveWallpaperScale
                height: bgRoot.screen.height * bgRoot.effectiveWallpaperScale
            }
        }

        // Screen lock

        // Widgets
    }
}