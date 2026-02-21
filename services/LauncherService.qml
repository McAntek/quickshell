pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: svc

    readonly property var apps: DesktopEntries.applications.values
    property var results: []
    property var recents: StorageService.recents

    readonly property string commandPrefix: "$"

    Component.onCompleted: {
        filter("")
    }

    function isCommand(query) {
        return query.startsWith(commandPrefix)
    }

    function extractCommand(query) {
        return query.slice(commandPrefix.length).trim()
    }

    function commandResult(command) {
        return {
            type: "command",
            name: command,
            summary: "Run shell command",
            command: command
        }
    }

    
    function launchCommand(command) {
        Qt.createQmlObject(`
            import Quickshell.Io

            Process {
                running: true
                command: ["bash", "-c", "` + command.replace(/"/g, '\\"') + `"]
            }
        `, svc)
    }

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
        if (isCommand(query)) {
            const cmd = extractCommand(query)
            results = cmd.length ? [commandResult(cmd)] : []
            return
        }

        if (!query || query.length === 0) {
            results = apps
                .map(app => ({
                    type: "app",
                    app: app,
                    name: app.name,
                    s: (recents[app.name] || 0)
                }))
                .sort((a, b) => b.s - a.s)

            return
        }

        results = apps
            .map(app => ({
                type: "app",
                app: app,
                name: app.name,
                s: score(app, query) + (recents[app.name] || 0) * 10
            }))
            .filter(o => o.s > 0)
            .sort((a, b) => b.s - a.s)

        if (results.length === 0) {
            results = [commandResult(query)]
        }
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
            if (StorageService.loaded)
                filter("")
        }

        function onRecentsChanged() {
            filter("")
        }
    }
}