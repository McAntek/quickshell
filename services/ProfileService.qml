import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: service

    property string profile: ""

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: triggerGetProfile()
    }

    function triggerGetProfile() {
        getProfileProcess.running = true
    }

    function cycleProfile() {
        cycleProfileProcess.running = true
    }

    Process {
        id: getProfileProcess
        running: false
        command: ["bash", "-c", "asusctl profile get | head -n1 | awk '{ print $3 }'"]
        stdout: StdioCollector {
            onStreamFinished: {
                service.profile = text.trim()
            }
        }
    }

    Process {
        id: cycleProfileProcess
        running: false
        command: ["bash", "-c", "asusctl profile next"]
        onExited: {
            service.triggerGetProfile()
        }
    }
}
