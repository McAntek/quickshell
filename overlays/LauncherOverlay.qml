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
    margins.left: Screen.width / 2 - implicitWidth / 2
    margins.top: Screen.height / 4

    implicitWidth: 520
    implicitHeight: 420

    function launchAndReset(app) {
        AppService.launch(app)
        search.text = ""
        AppService.filter("")
        list.currentIndex = 0
        launcher.visible = false
    }


    Rectangle {
        id: container
        anchors.fill: parent
        radius: 14
        color: RosePine.base
        border.color: RosePine.overlay

        Keys.onEscapePressed: launcher.visible = false
        Keys.onPressed: {
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
                    AppService.filter(text)
                    list.currentIndex = 0
                }

                Keys.onPressed: function(event){
                    if (event.key === Qt.Key_Down) {
                        list.currentIndex = Math.min(
                            list.currentIndex + 1,
                            list.count - 1
                        )
                        event.accepted = true
                        return
                    }

                    if (event.key === Qt.Key_Up) {
                        list.currentIndex = Math.max(
                            list.currentIndex - 1,
                            0
                        )
                        event.accepted = true
                        return
                    }

                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        const app = AppService.results[list.currentIndex]
                        if (app) {
                            launchAndReset(app)
                        }
                        event.accepted = true
                        return
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

                model: AppService.results
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

                        Image {
                            width: 24
                            height: 24
                            source: Quickshell.iconPath(
                                AppService.icon(modelData),
                                true
                            )
                        }

                        Text {
                            text: modelData.name
                            color: RosePine.text
                            font.family: RosePine.fontFamily
                            font.pixelSize: RosePine.fontSize
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            list.currentIndex = index
                            launchAndReset(app)
                        }
                    }
                }
            }
        }
    }

    Behavior on visible {
        NumberAnimation { duration: 120 }
    }
}
