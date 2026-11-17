// Horizontal 0..1 slider; emits moved() while pressed or dragged.
import QtQuick

Item {
    id: slider
    property real value: 0
    signal moved(real value)

    readonly property real knob: 14
    readonly property real fraction: Math.max(0, Math.min(1, value))

    implicitHeight: Theme.rowHeight

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 4
        radius: height / 2
        color: Theme.highlight

        Rectangle {
            width: slider.fraction * parent.width
            height: parent.height
            radius: height / 2
            color: Theme.pine
        }
    }
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: slider.fraction * (slider.width - slider.knob)
        width: slider.knob
        height: slider.knob
        radius: slider.knob / 2
        color: Theme.pine
    }
    MouseArea {
        anchors.fill: parent
        function update(mx) {
            slider.moved(Math.max(0, Math.min(1, (mx - slider.knob / 2) / (slider.width - slider.knob))));
        }
        onPressed: mouse => update(mouse.x)
        onPositionChanged: mouse => {
            if (pressed)
                update(mouse.x);
        }
    }
}
