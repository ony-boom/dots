// Dropdown under the bar's right edge. Children are stacked inside the card.
// A transparent window below the bar catches outside clicks and dismisses it.
// Opens instantly (no entrance animation, like any menu); mango also has
// animations off for the "qs-menu" layers.
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: scope
    required property var screen
    property bool open: false
    property bool wantsKeyboard: false // e.g. a password field is showing
    signal dismissed

    default property alias content: body.data

    PanelWindow {
        screen: scope.screen
        visible: scope.open
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        margins.top: Theme.barHeight
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "qs-menu-dismiss"
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: scope.dismissed()
        }
    }

    PanelWindow {
        screen: scope.screen
        visible: scope.open
        anchors {
            top: true
            right: true
        }
        margins {
            top: Theme.barHeight + Theme.spaceXs
            right: Theme.spaceSm
        }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-menu"
        WlrLayershell.keyboardFocus: scope.wantsKeyboard ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand
        implicitWidth: Theme.menuWidth
        implicitHeight: body.implicitHeight + 2 * Theme.spaceSm
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusCard
            color: Theme.surface
            border.width: 1
            border.color: Theme.border
            focus: true
            Keys.onEscapePressed: scope.dismissed()

            Column {
                id: body
                anchors.fill: parent
                anchors.margins: Theme.spaceSm
                spacing: Theme.rowGap
            }
        }
    }
}
