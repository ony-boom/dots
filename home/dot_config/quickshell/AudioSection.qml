// One direction (output or input): mute button, volume slider, and the devices to pick from.
import QtQuick

Column {
    id: section
    property string title
    property string icon
    property string mutedIcon
    property var current: null // the default PwNode, or null
    property var devices: []
    signal pick(var node)

    readonly property var audio: current ? current.audio : null
    readonly property real volume: audio ? audio.volume : 0
    readonly property bool muted: audio ? audio.muted : false

    width: parent ? parent.width : 0
    spacing: Theme.rowGap

    Label {
        leftPadding: Theme.spaceSm
        topPadding: Theme.spaceXs
        text: section.title
        color: Theme.subtle
        font.pixelSize: Theme.fontSizeSmall
    }

    Row {
        visible: section.audio !== null
        width: parent.width
        height: Theme.rowHeight

        BarButton {
            id: mute
            implicitWidth: Theme.rowHeight
            inset: 0
            implicitHeight: Theme.rowHeight
            text: section.muted ? section.mutedIcon : section.icon
            color: section.muted ? Theme.love : Theme.text
            onClicked: section.audio.muted = !section.audio.muted
        }
        Slider {
            width: parent.width - mute.width - percent.width
            height: parent.height
            value: section.volume
            onMoved: v => section.audio.volume = v
        }
        Label {
            id: percent
            width: 3 * Theme.spaceLg
            height: parent.height
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            rightPadding: Theme.spaceSm
            text: Math.round(section.volume * 100) + "%"
            color: Theme.subtle
            font.bold: false
        }
    }

    Repeater {
        model: section.devices

        MenuRow {
            required property var modelData
            text: modelData.description || modelData.nickname || modelData.name
            selected: modelData === section.current
            onClicked: section.pick(modelData)
        }
    }
}
