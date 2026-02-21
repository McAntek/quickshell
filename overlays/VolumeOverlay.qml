import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

import "../themes"
Scope {
	id: root

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	property bool shouldShowOsd: false

	function volumeIcon(p) {
		if (p == 0) return ""
		if (p <= 0.5) return ""
		return ""
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			anchors.bottom: true
			margins.bottom: screen.height / 16
			exclusiveZone: 0

			implicitWidth: 400
			implicitHeight: 50
			color: RosePine.trans

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				radius: height / 2
				color: RosePine.base

				RowLayout {
					spacing: 10
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					Text {
						id: label
						text: volumeIcon(Pipewire.defaultAudioSink?.audio.volume)
						color: RosePine.text
						font.family: RosePine.fontFamily
						font.pixelSize: 30
					}

					Rectangle {
						Layout.fillWidth: true

						implicitHeight: 10
						radius: 20
						color: RosePine.hHigh

						Rectangle {
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
							radius: parent.radius
						}
					}
				}
			}
		}
	}
}