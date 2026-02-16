pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

Item {
    id: service

    property var recents: ({})
    property bool loaded: false

    FileView {
        id: recentsFile
        path: "/home/mcantek/.config/quickshell/recents.json"

        watchChanges: true

        JsonAdapter {
            property var savedRecents: ({})
        }

        onLoaded: {
            service.recents = adapter.savedRecents || {}
            service.loaded = true
        }

        onFileChanged: reload()

        onAdapterUpdated: {
            if (!service.loaded) return
            writeAdapter()
        }
    }

    onRecentsChanged: {
        if (!loaded) return
        recentsFile.adapter.savedRecents = Object.assign({}, recents)
    }

    function bump(appName) {
        let r = Object.assign({}, recents)
        r[appName] = (r[appName] || 0) + 1
        recents = r
    }
}
