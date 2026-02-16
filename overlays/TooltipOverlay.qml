import Quickshell
import Quickshell.Wayland
import QtQuick
import "../themes"

PanelWindow {
	id: tooltip

	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.exclusiveZone: -1

	visible: false
	color: "transparent"

	anchors.top: true
	anchors.left: true


	property real px: 0
	property real py: 0
	property string text: ""

	margins.left: px
	margins.top: py
	
	implicitWidth: bubble.implicitWidth
	implicitHeight: bubble.implicitHeight

	Rectangle {
		id: bubble
		anchors.fill: parent
		color: RosePine.base
		radius: 8
		border.color: RosePine.overlay

		opacity: tooltip.visible ? 1 : 0

		Behavior on opacity {
			NumberAnimation { duration: 120 }
		}

		implicitWidth: label.implicitWidth + 20
		implicitHeight: label.implicitHeight + 14

		Text {
			id: label
			anchors.centerIn: parent
			text: tooltip.text
			color: RosePine.text
			font.family: RosePine.fontFamily
			font.pixelSize: RosePine.fontSize * 0.85
		}
	}
}
