import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

Button {
    id: sidebar_btn
    property string page: "system"

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 10
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true // Enable hover events for cursor changes
        cursorShape: Qt.PointingHandCursor // Change cursor to a pointing hand
        onClicked: {
            win.currentPage = sidebar_btn.page
        }
    }
    background: Rectangle {
        width: 180
        color: win.currentPage === sidebar_btn.page ? "orange" : sidebar_btn.hovered ? "#5d5d5d5d" : "#00ffffff"
        radius: 5
    }
    anchors.horizontalCenter: parent.horizontalCenter
    contentItem: RowLayout {
        spacing: 5
                
        Image {
            source: "qrc:/icons/my_icon.png" // Replace with your icon path
            width: 20
            height: 20
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
        }

        Text {
            text: sidebar_btn.page
            font.pixelSize: 16
            anchors.left: parent.left
            color: "white"
            verticalAlignment: Text.AlignVCenter
        }
    }
}