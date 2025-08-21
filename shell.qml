//@ pragma UseQApplication

import QtQuick
import Quickshell

import qs.services

import "modules"
import "./modules/Taskbar/"

ShellRoot {
    // ThemeConfig {
    //     id: theme
    // }

    // FontLoader {
    //     source: theme.fontFamily.includes("/") ? theme.fontFamily : ""
    // }

    // FontMetrics {
    //     id: fontMetrics
    //     font.family: theme.fontFamily
    //     font.pixelSize: theme.fontSize
    // }

    Taskbar{}

    Shortcuts{}
}