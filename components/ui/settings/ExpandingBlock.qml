import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: parent.width
    anchors.left: parent.left
    anchors.right: parent.right
    height: expanded ? expandedHeight : 60

    property bool expanded: false
    property int expandedHeight: 150
    property string mainText: "Нажми меня"
    property var options: [{ label: "First monitor" }, { label: "Option 2" }, { label: "Option 3" }]
    property color bgColor: "#665f5f5f"
    property int animationDuration: 200
    property var previous: null
    property bool disableYAnimation: false

    Rectangle {
        id: rect
        anchors.fill: parent
        color: bgColor
        border.width: 1
        border.color: expanded ? "#2fffffff" : "transparent"
        radius: 10
        
        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            spacing: 5

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 18
                height: 60

                Text {
                    color: "#fff"
                    text: mainText
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }

                Text {
                    color: "#fff"
                    text: expanded ? "CLOSE" : "OPEN"
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignRight
                }
            }

            ListView {
                id: optionsList
                anchors.fill: parent
                Layout.fillWidth: true
                Layout.fillHeight: true
                width: parent.width
                
                opacity: expanded ? 1 : 0
                visible: expanded
                clip: true 
                model: options
                anchors.topMargin: 60
                spacing: 20

                delegate: Item {
                    Text {
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        color: "#fff"
                        font.weight: Font.Semibold
                        text: modelData.label
                    }
                }
            }
        }

        Behavior on height {
            NumberAnimation { duration: animationDuration; easing.type: Easing.InOutQuad }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                expanded = !expanded
            }
        }
    }

    // To auto align blocks
    Connections {
        target: previous
        onYChanged: {
            disableYAnimation = true
            root.y = previous.expanded ? (previous.y + previous.expandedHeight + 10) : (previous.y + 70);
        }
        onExpandedChanged: {
            disableYAnimation = false
            root.y = previous.expanded ? (previous.y + previous.expandedHeight + 10) : (previous.y + 70);
        }
    }

    Behavior on height {
        NumberAnimation { duration: animationDuration; easing.type: Easing.InOutQuad }
    }

    Behavior on y {
        NumberAnimation { duration: disableYAnimation ? 0 : animationDuration; easing.type: Easing.InOutQuad }
    }
}