// Menu title with an on/off switch; the whole row is the click target.
import QtQuick

Item {
    id: header
    property string title
    property bool checked
    signal toggled

    readonly property int trackHeight: 20
    readonly property int trackInset: 3 // knob gap, so the knob is concentric with the track

    width: parent ? parent.width : 0
    implicitHeight: Theme.rowHeight

    Label {
        anchors.left: parent.left
        anchors.leftMargin: Theme.spaceSm
        anchors.verticalCenter: parent.verticalCenter
        text: header.title
    }
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: Theme.spaceSm
        anchors.verticalCenter: parent.verticalCenter
        width: 2 * header.trackHeight - header.trackInset
        height: header.trackHeight
        radius: height / 2
        color: header.checked ? Theme.pine : Theme.highlight

        Rectangle {
            readonly property int size: header.trackHeight - 2 * header.trackInset
            anchors.verticalCenter: parent.verticalCenter
            x: header.checked ? parent.width - width - header.trackInset : header.trackInset
            width: size
            height: size
            radius: size / 2
            color: Theme.surface

            Behavior on x {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
    TapHandler {
        onTapped: header.toggled()
    }
}
