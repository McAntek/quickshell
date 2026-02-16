import QtQuick
import "../themes"

Rectangle {
	radius: height / 3
	height: RosePine.fontSize * 2
	implicitWidth: clock.implicitWidth + 20

	color: RosePine.base
	id: root

	property var tooltip

	Text {
		id: clock

		property bool showDate: false

		text: (showDate
			? Qt.formatDateTime(new Date(), "ddd, MMM dd")
			: Qt.formatDateTime(new Date(), "HH:mm"))

		color: RosePine.text
		font.family: RosePine.fontFamily
		font.pixelSize: RosePine.fontSize
		anchors.centerIn: parent

		Timer {
			interval: 100
			running: true
			repeat: true
			onTriggered: clock.text = (clock.showDate
				? Qt.formatDateTime(new Date(), "dd-MM-yyyy")
				: Qt.formatDateTime(new Date(), "HH:mm"))
		}
	}

	Behavior on implicitWidth {
		NumberAnimation {
			duration: 180
			easing.type: Easing.OutQuad
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor

		onEntered: {
			const pos = root.mapToGlobal(Qt.point(0, 0))

			tooltip.text =
				Qt.formatDateTime(
					new Date(), "dddd, dd MMMM yyyy")

			tooltip.px = pos.x - tooltip.width / 2
			tooltip.py = pos.y + tooltip.height / 2 + 8 + RosePine.fontSize

			tooltip.visible = true
		}

		onExited: {
			tooltip.visible = false
		}

		onClicked: clock.showDate = !clock.showDate
	}
}
