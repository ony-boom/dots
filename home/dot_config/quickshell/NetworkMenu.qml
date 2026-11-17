// Wi-Fi: switch plus the list of networks in range (nmcli).
// Click connects; secured networks you haven't joined before ask for a password.
import QtQuick
import Quickshell.Io

Column {
    id: menu
    property bool shown: false // set by the bar while this menu is the open one
    readonly property bool wantsKeyboard: pendingSsid !== ""

    property bool wifiOn: true
    property var networks: [] // [{ ssid, signal, secure, active, saved }]
    property string status: ""
    property string pendingSsid: "" // network waiting for a password

    width: parent ? parent.width : 0
    spacing: Theme.rowGap

    onShownChanged: {
        pendingSsid = "";
        status = "";
        if (shown) {
            scan.running = true;
            refresh();
        }
    }

    function refresh() {
        if (!list.running)
            list.running = true;
    }

    // nmcli -t escapes ':' and '\' inside values with a backslash
    function splitTerse(line) {
        const out = [];
        let cur = "";
        for (let i = 0; i < line.length; i++) {
            const c = line[i];
            if (c === "\\" && i + 1 < line.length)
                cur += line[++i];
            else if (c === ":") {
                out.push(cur);
                cur = "";
            } else
                cur += c;
        }
        out.push(cur);
        return out;
    }

    // output = radio state, "---", saved connections, "---", wifi list
    function parse(output) {
        const sections = output.split("---\n");
        wifiOn = sections[0].trim() === "enabled";

        const saved = new Set();
        for (const line of (sections[1] ?? "").split("\n")) {
            const [name, type] = splitTerse(line);
            if (name && (type === "802-11-wireless" || type === "wifi"))
                saved.add(name);
        }

        const bySsid = {};
        for (const line of (sections[2] ?? "").split("\n")) {
            if (!line)
                continue;
            const [inUse, ssid, signal, security] = splitTerse(line);
            if (!ssid)
                continue;
            const entry = {
                ssid: ssid,
                signal: parseInt(signal) || 0,
                secure: !!security && security !== "--",
                active: inUse === "*",
                saved: saved.has(ssid)
            };
            const prev = bySsid[ssid];
            if (!prev)
                bySsid[ssid] = entry;
            else {
                prev.active = prev.active || entry.active;
                prev.signal = Math.max(prev.signal, entry.signal);
            }
        }
        networks = Object.values(bySsid).sort((a, b) => (b.active - a.active) || (b.signal - a.signal));
    }

    function exec(command, message) {
        status = message;
        run.command = command;
        run.running = true;
    }

    function connectTo(ssid, password) {
        const command = ["nmcli", "device", "wifi", "connect", ssid];
        if (password)
            command.push("password", password);
        exec(command, "Connecting to " + ssid + "…");
    }

    function choose(network) {
        if (network.active)
            exec(["nmcli", "connection", "down", "id", network.ssid], "");
        else if (network.saved || !network.secure)
            connectTo(network.ssid, "");
        else
            pendingSsid = network.ssid;
    }

    Process {
        id: list
        command: ["sh", "-c", "nmcli radio wifi; echo ---; nmcli -t -f NAME,TYPE connection show; echo ---; nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list --rescan no"]
        stdout: StdioCollector {
            onStreamFinished: menu.parse(text)
        }
    }
    Process {
        id: scan
        command: ["nmcli", "device", "wifi", "rescan"]
    }
    Process {
        id: run
        onExited: code => {
            menu.status = code === 0 ? "" : "Failed";
            menu.pendingSsid = "";
            menu.refresh();
        }
    }
    // keep the list fresh while the menu is open
    Timer {
        interval: 6000
        repeat: true
        running: menu.shown
        onTriggered: {
            if (!scan.running)
                scan.running = true;
            menu.refresh();
        }
    }

    MenuHeader {
        title: "Wi-Fi"
        checked: menu.wifiOn
        onToggled: menu.exec(["nmcli", "radio", "wifi", menu.wifiOn ? "off" : "on"], "")
    }

    Label {
        visible: !menu.wifiOn
        leftPadding: Theme.spaceSm
        bottomPadding: Theme.spaceSm
        text: "Wi-Fi is off"
        color: Theme.subtle
        font.bold: false
    }
    Label {
        visible: menu.wifiOn && menu.networks.length === 0
        leftPadding: Theme.spaceSm
        bottomPadding: Theme.spaceSm
        text: "Scanning…"
        color: Theme.subtle
        font.bold: false
    }

    // at most 8 rows tall, then scrolls
    Flickable {
        visible: menu.wifiOn && menu.networks.length > 0
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
                model: menu.networks

                MenuRow {
                    required property var modelData
                    text: modelData.ssid
                    detail: (modelData.secure ? Theme.iconLock + " " : "") + modelData.signal + "%"
                    selected: modelData.active
                    onClicked: menu.choose(modelData)
                }
            }
        }
    }

    Column {
        visible: menu.pendingSsid !== ""
        width: parent.width
        spacing: Theme.spaceXs

        Label {
            leftPadding: Theme.spaceSm
            topPadding: Theme.spaceXs
            text: "Password for " + menu.pendingSsid
            color: Theme.subtle
            font.bold: false
            font.pixelSize: Theme.fontSizeSmall
        }
        Rectangle {
            width: parent.width
            height: Theme.rowHeight
            radius: Theme.radiusRow
            color: Theme.base
            border.width: 1
            border.color: Theme.border

            TextInput {
                id: password
                anchors.fill: parent
                anchors.leftMargin: Theme.spaceSm
                anchors.rightMargin: Theme.spaceSm
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                passwordCharacter: "•"
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                visible: menu.pendingSsid !== ""
                onVisibleChanged: {
                    if (visible) {
                        text = "";
                        forceActiveFocus();
                    }
                }
                onAccepted: if (text.length > 0) menu.connectTo(menu.pendingSsid, text)
            }
        }
    }

    Label {
        visible: menu.status !== ""
        leftPadding: Theme.spaceSm
        topPadding: Theme.spaceXs
        text: menu.status
        color: Theme.subtle
        font.bold: false
        font.pixelSize: Theme.fontSizeSmall
    }
}
