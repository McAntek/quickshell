import Quickshell
import Quickshell.Wayland

import QtQuick
import QtQuick.Layouts
import "../themes"
import "../services"

PanelWindow {
    id: launcher

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    visible: false
    color: "transparent"

    anchors.top: true
    anchors.left: true
    margins.left: (screen.width - implicitWidth) / 2
    margins.top: (screen.height - implicitHeight) / 2

    implicitWidth: 520
    implicitHeight: 420

    function launchAndReset(app) {
        LauncherService.launch(app)
        search.text = ""
        LauncherService.filter("")
        list.currentIndex = 0
        launcher.visible = false
    }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: RosePine.base
        border.color: RosePine.overlay

        Keys.onEscapePressed: launcher.visible = false

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) {
                launcher.visible = false
                event.accepted = true
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            TextInput {
                id: search
                Layout.fillWidth: true
                focus: true

                font.family: RosePine.fontFamily
                font.pixelSize: RosePine.fontSize * 1.2
                color: RosePine.text

                onTextChanged: {
                    LauncherService.filter(text)
                    list.currentIndex = 0
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Down) {
                        list.currentIndex = Math.min(list.currentIndex + 1, list.count - 1)
                        event.accepted = true
                        return
                    }

                    if (event.key === Qt.Key_Up) {
                        list.currentIndex = Math.max(list.currentIndex - 1, 0)
                        event.accepted = true
                        return
                    }

                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        const item = LauncherService.results[list.currentIndex]
                        if (!item) return

                        if (item.type === "command") {
                            LauncherService.launchCommand(item.command)
                            search.text = ""
                            LauncherService.filter("")
                            launcher.visible = false
                        }
                        else {
                            launchAndReset(item.app)
                        }

                        event.accepted = true
                    }
                }
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: RosePine.overlay
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: LauncherService.results
                currentIndex: 0
                clip: true

                onCurrentIndexChanged:
                    positionViewAtIndex(currentIndex, ListView.Contain)

                delegate: Rectangle {
                    width: list.width
                    height: 42
                    radius: 6

                    color: ListView.isCurrentItem
                        ? RosePine.overlay
                        : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 80 }
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10
                        padding: 4

                        Image {
                            width: 24
                            height: 24
                            source: modelData.type !== "command" ? Quickshell.iconPath(
                                    LauncherService.icon(modelData.app),
                                    true
                                ) : "terminal.svg"
                            visible: modelData.type !== "command"
                        }

                        Text {
                            text: ""
                            color: RosePine.text
                            font.family: RosePine.fontFamily
                            font.pixelSize: RosePine.fontSize * 2
                            visible: modelData.type === "command"
                        }

                        Column {
                            spacing: 2

                            Text {
                                text: modelData.name
                                color: RosePine.text
                                font.family: RosePine.fontFamily
                                font.pixelSize: RosePine.fontSize
                            }

                            Text {
                                visible: modelData.type === "command"
                                text: modelData.type === "command" ? modelData.summary : ""
                                color: RosePine.subtle
                                font.pixelSize: RosePine.fontSize * 0.8
                            }
                        }

                        
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            list.currentIndex = index
                            launchAndReset(modelData.app)
                        }
                        enabled: modelData.type !== "command"
                    }
                }
            }
        }

    }

    Behavior on visible {
        NumberAnimation { duration: 120 }
    }
}