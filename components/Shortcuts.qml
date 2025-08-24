import qs.components.misc
import qs.modules.settingswindow
import qs.services
import Quickshell
import Quickshell.Io

Scope {
    id: root

    CustomShortcut {
        name: "systemSettings"
        description: "Launch System Settings"
        onPressed: SettingsWindow.create()
    }

    IpcHandler {
        target: "systemSettings"

        function open(): void {
            SettingsWindow.create()
        }
    }
}