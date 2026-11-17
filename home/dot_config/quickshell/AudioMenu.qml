// Sound: output and input volume, mute, and which device is the default.
// Needs the default nodes bound by a PwObjectTracker (done once in shell.qml).
import QtQuick
import Quickshell.Services.Pipewire

Column {
    id: menu
    width: parent ? parent.width : 0
    spacing: Theme.spaceSm

    // hardware devices only (streams are individual programs)
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.audio && !n.isStream && n.isSink)
    readonly property var sources: Pipewire.nodes.values.filter(n => n.audio && !n.isStream && !n.isSink)

    AudioSection {
        title: "Output"
        icon: Theme.iconVolumeHigh
        mutedIcon: Theme.iconVolumeMuted
        current: Pipewire.defaultAudioSink
        devices: menu.sinks
        onPick: node => Pipewire.preferredDefaultAudioSink = node
    }
    AudioSection {
        title: "Input"
        icon: Theme.iconMic
        mutedIcon: Theme.iconMicMuted
        current: Pipewire.defaultAudioSource
        devices: menu.sources
        onPick: node => Pipewire.preferredDefaultAudioSource = node
    }
}
