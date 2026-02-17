import QtQuick
import "../services"
import "../themes"

Rectangle {
    id: root
    radius: height / 3
    height: RosePine.fontSize * 2
    implicitWidth: profileText.implicitWidth + 20
    color: RosePine.base

    ProfileService {
        id: profileService
    }

    Text {
        id: profileText
        anchors.centerIn: parent
        color: RosePine.text
        font.family: RosePine.fontFamily
        font.pixelSize: RosePine.fontSize

        text: profileService.profile.length > 0 ? profileService.profile : "…"
    }

	MouseArea {
        anchors.fill: parent
        onClicked: profileService.cycleProfile()
    }

	Behavior on implicitWidth {
		NumberAnimation {
			duration: 180
			easing.type: Easing.OutQuad
		}
	}
}
