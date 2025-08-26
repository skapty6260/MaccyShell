import qs.services
import qs.modules.common

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      anchors {
        top: true
        left: true
        right: true
      }
      color: "transparent"

      implicitHeight: 40
      WlrLayershell.layer: WlrLayer.Bottom

      Text {
        id: clock
        anchors.centerIn: parent
        color: Appearance.colors.text

        Process {
          // give the process object an id so we can talk
          // about it from the timer
          id: dateProc

          command: ["date"]
          running: true

          stdout: StdioCollector {
            onStreamFinished: clock.text = this.text
          }
        }

        // use a timer to rerun the process at an interval
        Timer {
          // 1000 milliseconds is 1 second
          interval: 1000

          // start the timer immediately
          running: true

          // run the timer again when it ends
          repeat: true

          // when the timer is triggered, set the running property of the
          // process to true, which reruns it if stopped.
          onTriggered: dateProc.running = true
        }
      }
    }
  }
}