import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: sidebar_delimeter
    property string text: "system"

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 10
    anchors.rightMargin: 10    

    Text {
        text: sidebar_delimeter.text
        width: parent.width
        font.pixelSize: 14
        color: "#44ffffff"
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 5
    }

    Rectangle {
        width: parent.width
        height: 1
        color: "#44ffffff"
    }
}