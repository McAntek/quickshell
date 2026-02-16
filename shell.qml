import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "themes"
import "components"
import "overlays"
import "services"

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true

    margins.top: 5
    margins.left: 7
    margins.right: 7

    implicitHeight: RosePine.fontSize * 2
    color: RosePine.trans

    // Left
    RowLayout {
        spacing: 6
        anchors.left: parent.left
    }

    // Middle
    WorkspacesComponent {
        anchors.centerIn: parent
    }

    // Right
    RowLayout {
        spacing: 6
        anchors.right: parent.right

        ClockComponent {
            tooltip: tooltip
        }

        BatteryComponent { }
    }

    TooltipOverlay {
        id: tooltip
    }

    LauncherOverlay {
        id: launcher
        visible: false
    }

    // ─────────────────────────────────────────────
    // IPC handler for external toggle (e.g. Hyprland)
    IpcHandler {
        id: launcherIpc
        target: "launcher"

        function toggle(): void {
            launcher.visible = !launcher.visible

            // focus search if opening
            if (launcher.visible && launcher.search)
                launcher.search.forceActiveFocus()
        }
    }

	// in shell.qml
//	StorageService { id: storageService }

}
