// One 36px menu row: name, optional detail text and a check mark for the selected one.
import QtQuick

Item {
    id: row
    property alias text: name.text
    property string detail: ""
    property bool selected: false
    property bool dimmed: false
    signal clicked

    width: parent ? parent.width : 0
    implicitHeight: Theme.rowHeight

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusRow
        color: hover.hovered ? Theme.overlay : "transparent"
    }
    Label {
        id: name
        anchors.left: parent.left
        anchors.leftMargin: Theme.spaceSm
        anchors.right: detailText.left
        anchors.rightMargin: Theme.spaceSm
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideRight
        font.bold: row.selected
        color: row.dimmed ? Theme.subtle : Theme.text
    }
    Label {
        id: detailText
        anchors.right: check.left
        anchors.verticalCenter: parent.verticalCenter
        text: row.detail
        color: Theme.subtle
        font.bold: false
        font.pixelSize: Theme.fontSizeSmall
    }
    Label {
        id: check
        anchors.right: parent.right
        anchors.rightMargin: Theme.spaceSm
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.spaceLg
        text: row.selected ? Theme.iconCheck : ""
        color: Theme.pine
    }
    HoverHandler {
        id: hover
    }
    TapHandler {
        onTapped: row.clicked()
    }
}
