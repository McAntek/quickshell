pragma Singleton

import QtQuick
import Quickshell

Item {
    id: svc

    readonly property var apps: DesktopEntries.applications.values
    property var results: apps
    property var recents: StorageService.recents

    function score(app, query) {
        const name = app.name.toLowerCase()
        query = query.toLowerCase()

        if (name.startsWith(query)) return 100
        if (name.includes(query)) return 60

        let qi = 0
        for (let i = 0; i < name.length && qi < query.length; i++) {
            if (name[i] === query[qi]) qi++
        }
        return qi === query.length ? 30 : 0
    }

    function filter(query) {
       if (!query || query.length === 0) {
            results = apps
                .map(app => ({
                    app,
                    s: (recents[app.name] || 0)
                }))
                .sort((a, b) => b.s - a.s)
                .map(o => o.app)
            return
        }


        results = apps
            .map(app => ({
                app,
                s: score(app, query) + (recents[app.name] || 0) * 10
            }))
            .filter(o => o.s > 0)
            .sort((a, b) => b.s - a.s)
            .map(o => o.app)
    }

    function icon(app) {
        if (!app.icon) return "application-x-executable"
        return app.icon
    }

    function launch(app) {
        StorageService.bump(app.name)

        filter("")
        Quickshell.execDetached({ command: app.command })
    }

    Connections {
        target: StorageService

        function onLoadedChanged() {
            if (StorageService.loaded) {
                filter("")
            }
        }

        function onRecentsChanged() {
            filter("")
        }
    }


}
