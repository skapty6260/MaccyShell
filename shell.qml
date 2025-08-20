//@ pragma UseQApplication

import QtQuick
import Quickshell

import "modules"
import "./modules/Taskbar/"

ShellRoot {
    Taskbar{}

    Shortcuts{}
}