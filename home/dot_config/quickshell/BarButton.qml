// Clickable bar item: at least 32px wide and the full bar height, so it is easy to hit.
import QtQuick

MouseArea {
    id: button
    property alias text: label.text
    property color color: Theme.text
    property bool active: false // its menu is open
    property int inset: Theme.spaceXs // gap between the hit area and the highlight

    implicitWidth: Math.max(Theme.hitTarget, label.implicitWidth + 2 * Theme.spaceSm)
    implicitHeight: Theme.barHeight
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

    // hover and open share one language: overlay, then the deeper highlight
    Rectangle {
        anchors.fill: parent
        anchors.margins: button.inset
        radius: Theme.radiusRow
        color: button.active ? Theme.highlight
             : button.containsMouse ? Theme.overlay : "transparent"
    }
    Label {
        id: label
        anchors.centerIn: parent
        color: button.color
    }
}
