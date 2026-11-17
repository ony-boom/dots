// Session lock: wallpaper, clock and a password field.
// Engage with `qs ipc call lock lock` (bound to Super+l in the mango config).
// Authenticates through pam/password.conf.
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

Scope {
    id: scope
    required property url wallpaper

    property string password: ""
    property bool failed: false

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    IpcHandler {
        target: "lock"
        function lock(): void {
            scope.password = "";
            scope.failed = false;
            session.locked = true;
        }
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            if (responseRequired)
                respond(scope.password);
        }
        onCompleted: result => {
            scope.password = "";
            if (result === PamResult.Success) {
                scope.failed = false;
                session.locked = false;
            } else {
                scope.failed = true;
            }
        }
    }

    WlSessionLock {
        id: session

        WlSessionLockSurface {
            color: Theme.base

            Image {
                anchors.fill: parent
                source: scope.wallpaper
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
            Rectangle {
                anchors.fill: parent
                color: Theme.base
                opacity: 0.55
            }

            Column {
                anchors.centerIn: parent
                spacing: Theme.spaceLg

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: 80
                    font.bold: true
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDateTime(clock.date, "dddd, d MMMM")
                    color: Theme.subtle
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLarge
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 300
                    height: 44
                    radius: height / 2
                    color: Theme.surface
                    border.width: scope.failed ? 2 : 1
                    border.color: scope.failed ? Theme.love : Theme.border

                    TextInput {
                        id: input
                        anchors.fill: parent
                        anchors.leftMargin: Theme.spaceLg
                        anchors.rightMargin: Theme.spaceLg
                        verticalAlignment: TextInput.AlignVCenter
                        horizontalAlignment: TextInput.AlignHCenter
                        echoMode: TextInput.Password
                        passwordCharacter: "•"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLarge
                        readOnly: pam.active
                        focus: true
                        text: scope.password
                        onTextEdited: scope.password = text
                        onAccepted: if (!pam.active && text.length > 0) pam.start()
                        Component.onCompleted: forceActiveFocus()

                        Text {
                            anchors.centerIn: parent
                            visible: input.text === ""
                            text: "Password"
                            color: Theme.muted
                            font: input.font
                        }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: pam.active ? "Checking…" : scope.failed ? "Wrong password" : " "
                    color: scope.failed ? Theme.love : Theme.subtle
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }
        }
    }
}
