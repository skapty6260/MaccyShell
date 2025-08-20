import Quickshell
import QtQuick
import QtQuick.Controls

Control {
    width: parent.width
    height: 60

    Rectangle {
        anchors.fill: parent
        anchors.margins: 10

        radius: 10
        color: "#75000000"

        TextInput {
            anchors.fill: parent
            anchors.margins: 10
            id: input
            width: 200
            height: 100
            color: "#fff"
            font.pointSize: 14
             clip: true

            Text {
                color: "#94ffffff"
                text: "Search"
                anchors.fill: parent
                font.pointSize: 14
                verticalAlignment: Text.AlignVCenter
                visible: input.text.length === 0
            }

            onTextChanged: console.log("Text changed to:", input.text)
        }
    }
}