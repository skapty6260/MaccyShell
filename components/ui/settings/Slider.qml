import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter

    Slider {
        id: slider
        from: 0
        to: 100
        value: 50 // Initial value
        Layout.alignment: Qt.AlignVCenter
    }
}