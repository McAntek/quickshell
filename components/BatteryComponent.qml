import QtQuick

import "../services"
import "../themes"

Rectangle {
	radius: height / 3
	height: RosePine.fontSize * 2
	implicitWidth: batteryText.implicitWidth + 20
	color: RosePine.base


	property real percent: BatteryService.percentage * 100
	property bool hovered: false
	property bool showTimeInstead: false


	signal showTooltip(int x, int y, string text)
	signal hideTooltip()


	function batteryIcon(p) {
		if (p <= 20) return ""
		if (p <= 40) return ""
		if (p <= 60) return ""
		if (p <= 80) return ""
		return ""
	}

	function formatTime(seconds) {
		if (!seconds || seconds <= 0) return "--:--"
		let h = Math.floor(seconds / 3600)
		let m = Math.floor((seconds % 3600) / 60)
		return h + "h " + m + "m"
	}

	Text {
		id: batteryText
		anchors.centerIn: parent
		color: BatteryService.charging
			? RosePine.pine
			: percent <= 20
				? RosePine.love
				: percent <= 30
					? RosePine.gold
					: RosePine.text
		font.family: RosePine.fontFamily
		font.pixelSize: RosePine.fontSize

		text: showTimeInstead
			? (BatteryService.charging
				? formatTime(BatteryService.timeToFull) + " "
				: formatTime(BatteryService.timeToEmpty) + " " + batteryIcon(percent))
			: (BatteryService.charging
				? " " + Math.round(percent) + "%"
				: batteryIcon(percent) + "  " + Math.round(percent) + "%")

	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true

		onEntered: {
			let pos = parent.mapToGlobal(0, parent.height + 6)

			let msg = BatteryService.charging
				? "Full in " + formatTime(BatteryService.timeToFull)
				: "Empty in " + formatTime(BatteryService.timeToEmpty)

			showTooltip(pos.x, pos.y, msg)
		}

		onExited: hideTooltip()

		onClicked: showTimeInstead = !showTimeInstead
	}

	Behavior on implicitWidth {
		NumberAnimation {
			duration: 180
			easing.type: Easing.OutQuad
		}
	}
}

