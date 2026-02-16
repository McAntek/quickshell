import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../themes"

Rectangle {
	radius: height / 3
	height: RosePine.fontSize * 2
	width:  RosePine.fontSize * Hyprland.workspaces.values.filter(ws => ws.id > 0).length * 2
	color: RosePine.base
	RowLayout{
		spacing: 0

	Repeater {
		model: Hyprland.workspaces.values
			.filter(ws => ws.id > 0)

		Rectangle {
			property int wsId: modelData.id
			property bool hovered: false
			property bool isActive: Hyprland.focusedWorkspace?.id === wsId

			radius: height / 3
			height: RosePine.fontSize * 2
			width: RosePine.fontSize * 2

			color: isActive
				? RosePine.rose
				: hovered 
					? RosePine.pine 
					: RosePine.trans

			Behavior on color {
				ColorAnimation { duration: 150 }
			}

			Text {
				anchors.centerIn: parent
				text: wsId
				font.pixelSize: RosePine.fontSize
				font.family: RosePine.fontFamily
				font.bold: false
				color: isActive || hovered
					? RosePine.base 
					: RosePine.text
			}

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				cursorShape: Qt.PointingHandCursor
				onClicked: Hyprland.dispatch("workspace " + wsId)
				onEntered: hovered = true
				onExited: hovered = false
			}
		}
	}
	}
}