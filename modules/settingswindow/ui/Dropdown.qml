import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: root

    implicitWidth: 300
    implicitHeight: 60
        
    property real radius: 20
    property color checkedColor: "red"
    property var optionData: null

    background: none;

    model: optionData.options
    delegate: Item {
        id: item
        width: root.implicitWidth
        height: root.implicitHeight

        // Use a MouseArea to detect hover events

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true // Enable hover detection
            cursorShape: Qt.PointingHandCursor

            onEntered: {
                item.hovered = true; // Set hovered state
            }

            onExited: {
                item.hovered = false; // Reset hovered state
            }
        }

        Rectangle {
            anchors.fill: parent
            color: item.hovered ? "#56000000" : "transparent"
            radius: root.radius
        }

        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            width: parent.width
            height: parent.height
            anchors.fill: parent
            spacing: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            Label {
                opacity: 0.9
                text: modelData
                font.pixelSize: 14
                color: item.hovered ? "#fff" : "#b7ffffff"
                Layout.fillWidth: true
                // verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 10
            }

            // Image {
            //  visible: root.currentIndex === index
            //  Layout.rightMargin: 10
            // }
        }


    }
}