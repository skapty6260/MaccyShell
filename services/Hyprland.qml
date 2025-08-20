pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    property var monitorsList: null
    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWsId: focusedWorkspace?.id ?? 1
    property string kbLayout: "?"

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor {
        return Hyprland.monitorFor(screen);
    }

    function parseMonitorOutput(output: string): void {
        const lines = output.trim().split("\n");
        console.log(JSON.stringify(lines[1]))
        const monitorList = [];

        let currentMonitor = {};

        for (let line of lines) {
            line = line.trim();
            if (line.startsWith("Monitor ")) {
                // If we encounter a new monitor, push the current one to the list
                if (Object.keys(currentMonitor).length > 0) {
                    monitorList.push(currentMonitor);
                }

                currentMonitor = { name: line.split(" ")[1] }; // Extract monitor name
            } else if (line.includes(":")) {
                const [key, value] = line.split(":").map(part => part.trim());
                currentMonitor[key] = value; // Add key-value pairs to the current monitor object
            }
        }

        // Force add monitor size to monitor object
        function extractDimensions(line) {
            let dimensionsPart = line.split('@')[0].trim();
            let dimensions = dimensionsPart.split('x');

            if (dimensions.length >= 2) {
                return {
                    width: parseInt(dimensions[0]),
                    height: parseInt(dimensions[1])
                };
            }

            return null;
        }

        if (lines[1].includes("@") || lines[1].includes("x")) {
            let dim = extractDimensions(lines[1]);

            if (dim) {
                currentMonitor["width"] = dim.width;
                currentMonitor["height"] = dim.height;
                currentMonitor["selectedMode"] = lines[1].replace("\t", "").split(" at")[0]
            }
        }

        // Push the last monitor if it exists
        if (Object.keys(currentMonitor).length > 0) {
            monitorList.push(currentMonitor);
        }

        root.monitorsList = monitorList;
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (n.endsWith("v2"))
                return;

            if (n === "activelayout") {
                root.kbLayout = event.parse(2)[1].slice(0, 2).toLowerCase();
            } else if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(n)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            } else if (["openwindow", "closewindow", "movewindow"].includes(n)) {
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            } else if (n.includes("mon")) {
                Hyprland.refreshMonitors();
            } else if (n.includes("workspace")) {
                Hyprland.refreshWorkspaces();
            } else if (n.includes("window") || n.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(n)) {
                Hyprland.refreshToplevels();
            }
        }
    }

    Process {
        running: true
        command: ["hyprctl", "monitors"]
        stdout: StdioCollector {
            onStreamFinished: function() {
                root.parseMonitorOutput(text); // Parse the output when the stream finishes
            }
        }
    }

    Process {
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: root.kbLayout = JSON.parse(text).keyboards.find(k => k.main).active_keymap.slice(0, 2).toLowerCase()
        }
    }
}