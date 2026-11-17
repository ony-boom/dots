// Bluetooth: switch plus known and nearby devices (BlueZ via Quickshell.Bluetooth).
// Click connects / disconnects a paired device, or starts pairing a new one.
import QtQuick
import Quickshell.Bluetooth

Column {
    id: menu
    property bool shown: false // set by the bar while this menu is the open one
    readonly property var adapter: Bluetooth.defaultAdapter

    width: parent ? parent.width : 0
    spacing: Theme.rowGap

    // scan for new devices only while the menu is open
    Binding {
        target: menu.adapter
        property: "discovering"
        value: menu.adapter !== null && menu.shown && menu.adapter.enabled
        when: menu.adapter !== null
    }

    // BlueZ reports the address as the name for devices that haven't announced one
    function named(device) {
        return device.name !== "" && !/^([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}$/.test(device.name);
    }

    function detail(device) {
        if (device.pairing)
            return "Pairing…";
        if (device.state === BluetoothDeviceState.Connecting)
            return "Connecting…";
        if (device.connected)
            return device.batteryAvailable ? Math.round(device.battery * 100) + "%" : "";
        return device.paired ? "" : "Pair";
    }

    function choose(device) {
        if (device.connected)
            device.disconnect();
        else if (device.paired)
            device.connect();
        else
            device.pair();
    }

    MenuHeader {
        visible: menu.adapter !== null
        title: "Bluetooth"
        checked: menu.adapter ? menu.adapter.enabled : false
        onToggled: menu.adapter.enabled = !menu.adapter.enabled
    }

    Label {
        visible: menu.adapter === null
        leftPadding: Theme.spaceSm
        bottomPadding: Theme.spaceSm
        text: "No Bluetooth adapter"
        color: Theme.subtle
        font.bold: false
    }
    Label {
        visible: menu.adapter !== null && !menu.adapter.enabled
        leftPadding: Theme.spaceSm
        bottomPadding: Theme.spaceSm
        text: "Bluetooth is off"
        color: Theme.subtle
        font.bold: false
    }

    // at most 8 rows tall, then scrolls
    Flickable {
        visible: menu.adapter !== null && menu.adapter.enabled
        width: parent.width
        height: Math.min(contentHeight, 8 * (Theme.rowHeight + Theme.rowGap))
        contentHeight: rows.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: rows
            width: parent.width
            spacing: Theme.rowGap

            Repeater {
                model: menu.adapter ? menu.adapter.devices : null

                MenuRow {
                    required property var modelData
                    visible: menu.named(modelData)
                    text: modelData.name
                    detail: menu.detail(modelData)
                    selected: modelData.connected
                    dimmed: !modelData.paired && !modelData.connected
                    onClicked: menu.choose(modelData)
                }
            }
        }
    }
}
