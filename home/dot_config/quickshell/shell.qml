// Top bar for mango: workspaces (tags) left, date/time centre,
// tray / sound / bluetooth / network / battery right. Colours: Theme.qml.
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower

ShellRoot {
    id: root

    Wallpaper {
        source: Theme.wallpaper
        fallback: Theme.base
    }
    Lock {
        wallpaper: Theme.wallpaper
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // ── network status: poll NetworkManager (the menu lives in NetworkMenu.qml) ──
    property string netIcon: Theme.iconOffline
    property string netLabel: ""
    property bool netDown: true

    Process {
        id: nm
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.netIcon = Theme.iconOffline;
                root.netLabel = "";
                root.netDown = true;
                for (const line of text.split("\n")) {
                    const [type, state, ...name] = line.split(":");
                    if (state !== "connected" || (type !== "wifi" && type !== "ethernet"))
                        continue;
                    root.netDown = false;
                    root.netIcon = type === "wifi" ? Theme.iconWifi : Theme.iconEthernet;
                    root.netLabel = type === "wifi" ? name.join(":") : "";
                    break;
                }
            }
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!nm.running) nm.running = true
    }

    // ── sound ────────────────────────────────────────────────────────────────
    // binds the default nodes so their volume / mute can be read and written
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
    readonly property var sinkAudio: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
    readonly property var sourceAudio: Pipewire.defaultAudioSource ? Pipewire.defaultAudioSource.audio : null
    readonly property real sinkVolume: sinkAudio ? sinkAudio.volume : 0
    readonly property bool sinkMuted: sinkAudio ? sinkAudio.muted : false
    readonly property bool sourceMuted: sourceAudio ? sourceAudio.muted : false
    readonly property string sinkIcon: sinkMuted ? Theme.iconVolumeMuted
        : sinkVolume < 0.34 ? Theme.iconVolumeLow
        : sinkVolume < 0.67 ? Theme.iconVolumeMedium : Theme.iconVolumeHigh

    // ── bluetooth ────────────────────────────────────────────────────────────
    readonly property var btAdapter: Bluetooth.defaultAdapter
    readonly property bool btOn: btAdapter ? btAdapter.enabled : false
    readonly property bool btConnected: Bluetooth.devices.values.length > 0

    // ── battery ──────────────────────────────────────────────────────────────
    readonly property var bat: UPower.displayDevice
    readonly property var batIcons: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    readonly property int batPercent: bat ? Math.round(bat.percentage * 100) : 0
    readonly property string batIcon: bat && bat.state === UPowerDeviceState.Charging
        ? "󰂄" : batIcons[Math.min(10, Math.floor(batPercent / 10))]

    // ── mango tags ───────────────────────────────────────────────────────────
    // `mmsg watch tags <output>` streams the tag state as JSON. The field names
    // (tag_index, is_active, is_urgent, client_count) come from mango's binary;
    // the overall shape is a guess, so the first line is logged (`qs log`).
    // If tags look wrong, fix them here and nowhere else.
    function parseTags(line) {
        let obj;
        try {
            obj = JSON.parse(line);
        } catch (e) {
            return null;
        }
        const list = Array.isArray(obj) ? obj : (obj.tags ?? obj.all_tags);
        if (!Array.isArray(list))
            return null;
        return list.map((t, i) => ({
            index: t.tag_index ?? t.index ?? i + 1,
            active: !!t.is_active,
            urgent: !!t.is_urgent,
            clients: t.client_count ?? 0
        }));
    }

    // ── notifications: quickshell is the org.freedesktop.Notifications daemon ──
    NotificationServer {
        id: notifications
        keepOnReload: true
        bodySupported: true
        onNotification: n => n.tracked = true
    }

    PanelWindow {
        screen: Quickshell.screens[0]
        anchors {
            top: true
            right: true
        }
        margins {
            top: Theme.barHeight + Theme.spaceXs
            right: Theme.spaceSm
        }
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: Theme.menuWidth
        implicitHeight: stack.implicitHeight
        visible: notifications.trackedNotifications.values.length > 0
        color: "transparent"

        Column {
            id: stack
            width: parent.width
            spacing: Theme.spaceSm

            Repeater {
                model: notifications.trackedNotifications

                Rectangle {
                    id: card
                    required property var modelData
                    width: stack.width
                    height: content.implicitHeight + 2 * Theme.spaceMd
                    radius: Theme.radiusCard
                    color: Theme.surface
                    border.width: 1
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.love : Theme.border

                    Column {
                        id: content
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: Theme.spaceMd
                        }
                        spacing: Theme.rowGap
                        Label {
                            width: parent.width
                            text: card.modelData.summary
                            elide: Text.ElideRight
                        }
                        Label {
                            width: parent.width
                            visible: text !== ""
                            text: card.modelData.body
                            color: Theme.subtle
                            font.bold: false
                            textFormat: Text.StyledText
                            wrapMode: Text.Wrap
                            maximumLineCount: 4
                            elide: Text.ElideRight
                        }
                    }
                    // click dismisses; critical ones stay until clicked
                    TapHandler {
                        onTapped: card.modelData.dismiss()
                    }
                    Timer {
                        interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout * 1000 : 6000
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        onTriggered: card.modelData.expire()
                    }
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: Theme.barHeight
            color: Theme.base

            // which dropdown is open on this screen: "", "audio", "bt" or "net"
            property string openMenu: ""
            function toggle(name) {
                openMenu = openMenu === name ? "" : name;
            }

            // tags 1-4 are always shown (like GNOME's workspaces); others only when in use
            property var tags: []
            property bool logged: false
            readonly property var shownTags: {
                const byIndex = {};
                for (const t of tags)
                    byIndex[t.index] = t;
                const out = [];
                for (let i = 1; i <= 9; i++) {
                    const t = byIndex[i] ?? { index: i, active: false, urgent: false, clients: 0 };
                    if (i <= 4 || t.active || t.urgent || t.clients > 0)
                        out.push(t);
                }
                return out;
            }

            Process {
                running: true
                command: ["mmsg", "watch", "tags", bar.modelData.name]
                stdout: SplitParser {
                    onRead: line => {
                        if (!bar.logged) {
                            bar.logged = true;
                            console.log("mmsg watch tags:", line);
                        }
                        const parsed = root.parseTags(line);
                        if (parsed)
                            bar.tags = parsed;
                    }
                }
            }

            Menu {
                screen: bar.modelData
                open: bar.openMenu !== ""
                wantsKeyboard: network.wantsKeyboard
                onDismissed: bar.openMenu = ""

                AudioMenu {
                    visible: bar.openMenu === "audio"
                }
                BluetoothMenu {
                    shown: bar.openMenu === "bt"
                    visible: shown
                }
                NetworkMenu {
                    id: network
                    shown: bar.openMenu === "net"
                    visible: shown
                }
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: Theme.spaceSm
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: bar.shownTags

                    Item {
                        id: pill
                        required property var modelData
                        width: Theme.hitTarget
                        height: Theme.barHeight

                        // active: bold; the rest regular and muted (empty ones more so)
                        Label {
                            anchors.centerIn: parent
                            text: pill.modelData.index
                            font.bold: pill.modelData.active
                            color: pill.modelData.active ? Theme.text
                                 : pill.modelData.urgent ? Theme.love
                                 : pill.modelData.clients > 0 ? Theme.subtle : Theme.muted
                        }
                        TapHandler {
                            onTapped: Quickshell.execDetached(["mmsg", "dispatch", "view," + pill.modelData.index + ",0"])
                        }
                    }
                }
            }

            Row {
                anchors.centerIn: parent
                spacing: Theme.spaceSm
                Label {
                    text: Qt.formatDateTime(clock.date, "ddd d MMM")
                    color: Theme.subtle
                }
                Label {
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: Theme.spaceXs
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.spaceSm
                    rightPadding: Theme.spaceSm
                    Repeater {
                        model: SystemTray.items

                        MouseArea {
                            id: trayItem
                            required property var modelData
                            width: Theme.iconSize
                            height: Theme.iconSize
                            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                            onClicked: mouse => {
                                if (mouse.button === Qt.LeftButton)
                                    modelData.activate();
                                else if (mouse.button === Qt.MiddleButton)
                                    modelData.secondaryActivate();
                                else if (modelData.hasMenu)
                                    modelData.display(bar, mapToItem(null, 0, 0).x, bar.height);
                            }
                            IconImage {
                                anchors.fill: parent
                                source: trayItem.modelData.icon
                            }
                        }
                    }
                }

                // sound: click opens the menu, scroll changes volume, middle click mutes
                BarButton {
                    text: root.sinkIcon + " " + Math.round(root.sinkVolume * 100) + "%"
                    color: root.sinkMuted ? Theme.muted : Theme.text
                    active: bar.openMenu === "audio"
                    onClicked: mouse => {
                        if (mouse.button === Qt.MiddleButton) {
                            if (root.sinkAudio)
                                root.sinkAudio.muted = !root.sinkAudio.muted;
                        } else
                            bar.toggle("audio");
                    }
                    onWheel: wheel => {
                        if (root.sinkAudio)
                            root.sinkAudio.volume = Math.max(0, Math.min(1, root.sinkAudio.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)));
                    }
                }
                BarButton {
                    text: root.sourceMuted ? Theme.iconMicMuted : Theme.iconMic
                    color: root.sourceMuted ? Theme.love : Theme.text
                    active: bar.openMenu === "audio"
                    onClicked: mouse => {
                        if (mouse.button === Qt.MiddleButton) {
                            if (root.sourceAudio)
                                root.sourceAudio.muted = !root.sourceAudio.muted;
                        } else
                            bar.toggle("audio");
                    }
                }

                BarButton {
                    visible: root.btAdapter !== null
                    text: !root.btOn ? Theme.iconBluetoothOff
                        : root.btConnected ? Theme.iconBluetoothConnected : Theme.iconBluetooth
                    color: !root.btOn ? Theme.muted : root.btConnected ? Theme.pine : Theme.text
                    active: bar.openMenu === "bt"
                    onClicked: bar.toggle("bt")
                }

                BarButton {
                    text: root.netIcon + (root.netLabel ? " " + root.netLabel : "")
                    color: root.netDown ? Theme.love : Theme.pine
                    active: bar.openMenu === "net"
                    onClicked: bar.toggle("net")
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.bat && root.bat.ready
                    leftPadding: Theme.spaceSm
                    rightPadding: Theme.spaceSm
                    text: root.batIcon + " " + root.batPercent + "%"
                    color: Theme.iris
                }
            }
        }
    }
}
