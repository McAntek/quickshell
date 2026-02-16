pragma Singleton

import QtQuick
import Quickshell.Services.UPower

QtObject {
	id: root

	property bool available: UPower.displayDevice?.isLaptopBattery ?? false

	property real percentage: UPower.displayDevice?.percentage ?? 1

	property var state: UPower.displayDevice.state
	property bool charging: state === UPowerDeviceState.Charging || state ===  UPowerDeviceState.PendingCharge

	property real timeToEmpty: UPower.displayDevice.timeToEmpty
	property real timeToFull: UPower.displayDevice.timeToFull
}
