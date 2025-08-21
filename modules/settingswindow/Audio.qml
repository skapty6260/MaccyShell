import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: audio_page
    anchors.fill: parent

    Rectangle {
        id: page
        // color: "#e0000000"
        anchors.fill: parent
        anchors.leftMargin: 200

        ScrollView {
            anchors.fill: parent
            width: parent.width
            contentHeight: 1000 // Adjust as needed
            clip: true

            ColumnLayout {
                id: columnLayout
                anchors.fill: parent
                anchors.margins: 30
                spacing: 40

                Text {
                    color: "red"
                    font.pointSize: 10
                    text: "Sinks: " + JSON.stringify(Audio.sinks[0]) // Debugging output
                }

                GroupBox {
                    title: "Input Devices"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 10

                        Text {
                            color: "yellow"
                            text: "Input : "+Audio.sources
                        }

                        // Populate Input Devices from Pipewire
                        Instantiator {
                            id: inputDeviceInstantiator
                            model: Audio.sources

                            delegate: RowLayout {
                                spacing: 10

                                ComboBox {
                                    id: inputDeviceComboBox
                                    width: 200
                                    model: Audio.sources // List of input devices
                                    currentIndex: 0
                                    onCurrentIndexChanged: {
                                        // Set the selected input device as default
                                        Audio.setAudioSource(Audio.sources[currentIndex]);
                                    }
                                }

                                Button {
                                    text: "Configure"
                                    onClicked: {
                                        console.log("Configure", Audio.sources[inputDeviceComboBox.currentIndex]?.name);
                                    }
                                }

                                // Volume Control for Input Device
                                Slider {
                                    id: inputVolumeSlider
                                    width: 150
                                    from: 0
                                    to: 1
                                    stepSize: 0.01
                                    value: Audio.sources[inputDeviceComboBox.currentIndex]?.audio?.volume ?? 0
                                    onValueChanged: {
                                        Audio.setNodeProperty(Audio.sources[inputDeviceComboBox.currentIndex], "volume", value);
                                    }
                                }

                                Button {
                                    text: Audio.sources[inputDeviceComboBox.currentIndex]?.audio?.muted ? "Unmute" : "Mute"
                                    onClicked: {
                                        Audio.setNodeProperty(Audio.sources[inputDeviceComboBox.currentIndex], "muted", !Audio.sources[inputDeviceComboBox.currentIndex]?.audio?.muted);
                                    }
                                }
                            }
                        }
                    }
                }

                // Output Devices Section
                GroupBox {
                    title: "Output Devices"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 10

                        Instantiator {
                            id: outputDeviceInstantiator
                            model: Audio.sinks // Use the sinks from the Pipewire service
                            delegate: RowLayout {
                                spacing: 10

                                ComboBox {
                                    id: outputDeviceComboBox
                                    width: 200
                                    model: Audio.sinks // List of output devices
                                    currentIndex: 0
                                    onCurrentIndexChanged: {
                                        // Set the selected output device as default
                                        Audio.setAudioSink(Audio.sinks[currentIndex]);
                                    }

                                    Text {
                                        color: "green"
                                        text: "Output devices"
                                    }
                                }

                                Button {
                                    text: "Configure"
                                    onClicked: {
                                        console.log("Configure", Audio.sinks[outputDeviceComboBox.currentIndex]?.name);
                                    }
                                }

                                // Volume Control for Output Device
                                Slider {
                                    id: outputVolumeSlider
                                    width: 150
                                    from: 0
                                    to: 1
                                    stepSize: 0.01
                                    value: Audio.sinks[outputDeviceComboBox.currentIndex]?.audio?.volume ?? 0
                                    onValueChanged: {
                                        Audio.setNodeProperty(Audio.sinks[outputDeviceComboBox.currentIndex], "volume", value);
                                    }
                                }

                                Button {
                                    text: Audio.sinks[outputDeviceComboBox.currentIndex]?.audio?.muted ? "Unmute" : "Mute"
                                    onClicked: {
                                        Audio.setNodeProperty(Audio.sinks[outputDeviceComboBox.currentIndex], "muted", !Audio.sinks[outputDeviceComboBox.currentIndex]?.audio?.muted);
                                    }
                                }
                            }
                        }
                    }
                }

                // Playback Processes Section
                GroupBox {
                    title: "Playback Processes"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 10

                        // Populate Playback Processes from Pipewire
                        Instantiator {
                            model: Audio.getPlaybackProcesses() // Get playback processes from the service
                            delegate: RowLayout {
                                spacing: 10

                                Label {
                                    text: modelData.name // Assuming modelData has a name property
                                    Layout.fillWidth: true
                                }

                                Button {
                                    text: "Stop"
                                    onClicked: {
                                        Audio.stopPlaybackProcess(modelData); // Stop the selected playback process
                                        console.log("Stopping", modelData.name);
                                    }
                                }
                            }
                        }
                    }
                }

                // Recording Processes Section
                GroupBox {
                    title: "Recording Processes"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 10

                        // Populate Recording Processes from Pipewire
                        Instantiator {
                            model: Audio.getRecordingProcesses() // Get recording processes from the service
                            delegate: RowLayout {
                                spacing: 10

                                Label {
                                    text: modelData.name // Assuming modelData has a name property
                                    Layout.fillWidth: true
                                }

                                Button {
                                    text: "Stop"
                                    onClicked: {
                                        Audio.stopRecordingProcess(modelData); // Stop the selected recording process
                                        console.log("Stopping", modelData.name);
                                    }
                                }
                            }
                        }
                    }
                }

                // Profiles Section
                GroupBox {
                    title: "Profiles"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 10

                        // Example Profile Selection
                        Instantiator {
                            model: ["Profile 1", "Profile 2", "Profile 3"]
                            delegate: RowLayout {
                                spacing: 10

                                ComboBox {
                                    width: 200
                                    model: ["Profile 1", "Profile 2", "Profile 3"]
                                    currentIndex: 0
                                }

                                Button {
                                    text: "Apply"
                                    onClicked: {
                                        console.log("Applying", modelData);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}