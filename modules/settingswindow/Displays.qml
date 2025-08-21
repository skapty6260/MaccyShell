import qs.services
import qs.components.ui.settings
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: displays_page
    anchors.fill: parent

    property int selectedMonitor: 0
    property var monitors: Hyprland.monitorsList
    property int overallExpandedArea: (deviceInfo.expandedHeight + 10) + (bigOptions.expandedHeight + 10) + 60 // 60 is margins for y axis

    Rectangle {
        id: page
        color: ThemeConfig.windowBackground //"#e0000000"
        anchors.fill: parent
        anchors.leftMargin: 200

        ColumnLayout {
            anchors.fill: parent
            spacing: 40

            // Display Selector
            Rectangle {
                id: displaySelector
                height: 250
                anchors.left: parent.left 
                anchors.top: parent.top
                anchors.right: parent.right

                color: "#40747474"

                ListView {
                    height: 200
                    width: Math.min(
                        300 * displays_page.monitors.length,
                        parent.width * 0.8
                    )
                    anchors.centerIn: parent
                    
                    focus: true
                    clip: true

                    id: monitors_grid
                    model: displays_page.monitors // Hyprland.monitorsList

                    orientation: ListView.Horizontal
                    spacing: 30

                    delegate: Rectangle {
                        id: monitor_border
                        color: displays_page.selectedMonitor === index ? "white" : "transparent"
                        width: 275
                        height: 150
                        transform: Rotation {
                            origin.x: parent.x / 2 // Set origin x to the center of the rectangle
                            origin.y: parent.y / 2 // Set origin y to the center of the rectangle
                            angle: modelData.transform * 90 // Rotate by 45 degrees
                        }

                        MouseArea {
                            id: mousearea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
    
                            onClicked: {
                                displays_page.selectedMonitor = index
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 2
                                color: "darkgray"

                                Text {
                                    anchors.centerIn: parent
                                    color: "#fff"
                                    text: index + "\n" + modelData.width + "X" + modelData.height
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: 16
                                }
                            }
                        }
                    }
                }
            }

            // Current display options
            ScrollView {
                anchors.fill: parent
                width: parent.width
                anchors.topMargin: displaySelector.height // Make space for the header
                contentHeight: overallExpandedArea
                clip: true

                ColumnLayout {
                    id: columnLayout
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 40

                    RowLayout {
                        id: upperRow
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 80
                        spacing: 50

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            height: parent.height
                            width: parent.width

                            color: "red"
                        }

                        // Item {
                        //     height: parent.height

                        //     RowLayout {
                        //         anchors.fill: parent

                        //         property var modelData: null

                        //         Text {
                        //             wrapMode: Text.WordWrap
                        //             font.pixelSize: 16
                        //             color: "#fff"
                        //             font.weight: Font.Bold
                        //             text: "Brightness"
                        //             Layout.alignment: Qt.AlignVCenter
                        //             verticalAlignment: Text.AlignVCenter
                        //         }

                        //         Slider {}
                        //     }
                        // }
                    }

                    // Расширенные настройки
                    ExpandingBlock {
                        id: deviceInfo
                        
                        anchors.top: parent.top
                        anchors.topMargin: upperRow.height + 40
                        mainText: "Device info"
                        options: [
                            { label: "Monitor Index: ", value: selectedMonitor, type: "info" },
                            { label: "Name: ", value: monitors[selectedMonitor].name, type: "info" },
                            { label: "Description: ", value: monitors[selectedMonitor].description, type: "info" },
                            { label: "Color format: ", value: JSON.stringify(monitors[selectedMonitor].currentFormat), type: "info" },
                            { label: "Selected Mode: ", value: JSON.stringify(monitors[selectedMonitor].selectedMode), type: "info" },
                        ]
                        expandedHeight: 200
                    } 

                    ExpandingBlock {
                        id: bigOptions
                        mainText: "Graphics"
                        options: [
                            { label: "Selected Mode: ", value: JSON.stringify(monitors[selectedMonitor].selectedMode), type: "info" },
                            { label: "Mode: ", type: "dropdown" },
                            { label: "Brightness: ", value: "80%", type: "slider" },
                        ]
                        previous: deviceInfo
                        expandedHeight: 350
                    } 

                    // next blocks
                }
            }
        }
    }
}

// Блоки
/*
    1. Информация о мониторе
    2. Настройка изображения (Графика, режим монитора герцовка и качество, яркость, цветовой режим)
    3. Настройка возможностей (Повороты, ориентация, мирроринг, тиринг)
*/