pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // Collect all audio nodes (sinks and sources)
    readonly property var nodes: Pipewire.nodes.values.reduce((acc, node) => {
        if (!node.isStream) {
            if (node.isSink)
                acc.sinks.push(node);
            else if (node.audio)
                acc.sources.push(node);
        }
        return acc;
    }, {
        sources: [],
        sinks: []
    })

    readonly property list<PwNode> sinks: nodes.sinks
    readonly property list<PwNode> sources: nodes.sources

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: !!sink?.audio?.muted
    readonly property real volume: sink?.audio?.volume ?? 0

    // Set the volume for the default sink
    function setVolume(newVolume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, newVolume));
        }
    }

    // Increment the volume by a specified amount
    function incrementVolume(amount: real): void {
        setVolume(volume + (amount || 0.1)); // Default increment value
    }

    // Decrement the volume by a specified amount
    function decrementVolume(amount: real): void {
        setVolume(volume - (amount || 0.1)); // Default decrement value
    }

    // Mute or unmute the default sink
    function toggleMute(): void {
        if (sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    // Set the default audio sink
    function setAudioSink(newSink: PwNode): void {
        Pipewire.preferredDefaultAudioSink = newSink;
    }

    // Set the default audio source
    function setAudioSource(newSource: PwNode): void {
        Pipewire.preferredDefaultAudioSource = newSource;
    }

    // Get the list of all playback processes
    function getPlaybackProcesses(): var {
        return Pipewire.processes ? Pipewire.processes.filter(process => process.isPlayback) : [];
    }

    // Get the list of all recording processes
    function getRecordingProcesses(): var {
        return Pipewire.processes ? Pipewire.processes.filter(process => process.isRecording) : [];
    }

    // Stop a specific playback process
    function stopPlaybackProcess(process: PwProcess): void {
        if (process && process.isPlayback) {
            process.stop();
        }
    }

    // Stop a specific recording process
    function stopRecordingProcess(process: PwProcess): void {
        if (process && process.isRecording) {
            process.stop();
        }
    }

    // Set properties for a specific node (sink or source)
    function setNodeProperty(node: PwNode, property: string, value: var): void {
        if (node && node.audio) {
            node.audio[property] = value;
        }
    }

    // Track changes in audio objects
    PwObjectTracker {
        objects: [...root.sinks, ...root.sources]
    }
}