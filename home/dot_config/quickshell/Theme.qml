pragma Singleton
// Rosé Pine Dawn palette, font and icon glyphs (Nerd Font) shared by every file.
import QtQuick
import Quickshell

Singleton {
    readonly property color base: "#faf4ed"
    readonly property color surface: "#fffaf3"
    readonly property color overlay: "#f2e9e1"
    readonly property color highlight: "#dfdad9"
    readonly property color muted: "#9893a5"
    readonly property color subtle: "#797593"
    readonly property color text: "#575279"
    readonly property color love: "#b4637a"
    readonly property color pine: "#286983"
    readonly property color iris: "#907aa9"
    // semi-transparent so it works on any background
    readonly property color border: Qt.alpha(text, 0.14)

    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    // ── type scale (px) ──
    readonly property int fontSizeSmall: 12
    readonly property int fontSize: 14
    readonly property int fontSizeLarge: 18

    // ── spacing scale (px): use these, never one-off numbers ──
    readonly property int spaceXs: 4
    readonly property int spaceSm: 8
    readonly property int spaceMd: 12
    readonly property int spaceLg: 16

    // ── sizes ──
    readonly property int barHeight: 32
    readonly property int rowHeight: 36 // menu rows, inputs, sliders
    readonly property int hitTarget: 32 // smallest clickable thing
    readonly property int menuWidth: 320 // dropdowns and notifications
    readonly property int iconSize: 18 // tray icons
    readonly property int rowGap: 2 // between stacked rows

    // ── radii: a card's radius is its rows' radius plus its padding, so nested corners stay concentric ──
    readonly property int radiusRow: 6
    readonly property int radiusCard: radiusRow + spaceSm

    // same file GNOME uses as its wallpaper
    readonly property url wallpaper: "file://" + Quickshell.env("HOME") + "/.config/background"

    readonly property string iconWifi: "󰖩"
    readonly property string iconEthernet: "󰈀"
    readonly property string iconOffline: "󰖪"
    readonly property string iconLock: "󰌾"
    readonly property string iconCheck: "󰄬"
    readonly property string iconBluetooth: "󰂯"
    readonly property string iconBluetoothConnected: "󰂱"
    readonly property string iconBluetoothOff: "󰂲"
    readonly property string iconVolumeHigh: "󰕾"
    readonly property string iconVolumeMedium: "󰖀"
    readonly property string iconVolumeLow: "󰕿"
    readonly property string iconVolumeMuted: "󰝟"
    readonly property string iconMic: "󰍬"
    readonly property string iconMicMuted: "󰍭"
}
