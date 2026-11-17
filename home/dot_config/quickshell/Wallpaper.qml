// One background-layer window per screen showing `source`, cropped to fill.
import QtQuick
import Quickshell
import Quickshell.Wayland

Variants {
    id: wallpapers
    required property url source
    required property color fallback

    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "wallpaper"
        color: wallpapers.fallback

        Image {
            anchors.fill: parent
            source: wallpapers.source
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }
}
