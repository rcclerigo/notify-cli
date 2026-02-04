#!/usr/bin/env swift

import Cocoa
import AVFoundation
import Foundation

class NotifyDelegate: NSObject, NSApplicationDelegate {
    var title = "Notification"
    var message = ""
    var okLabel = "OK"
    var okURL: String?
    var iconType: String?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Play completion sound
        playCompletionSound()

        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "\(okLabel) ⏎")
        alert.addButton(withTitle: "Cancel")

        // Set Return key as default
        alert.buttons[0].keyEquivalent = "\r"

        // Set icon
        if let icon = iconType {
            switch icon.lowercased() {
            case "info", "informational":
                alert.alertStyle = .informational
            case "warning":
                alert.alertStyle = .warning
            case "critical", "error":
                alert.alertStyle = .critical
            default:
                // Try SF Symbol
                if #available(macOS 11.0, *) {
                    if let symbolImage = NSImage(systemSymbolName: icon, accessibilityDescription: nil) {
                        let config = NSImage.SymbolConfiguration(pointSize: 48, weight: .regular)
                        alert.icon = symbolImage.withSymbolConfiguration(config)
                    } else if let customIcon = NSImage(contentsOfFile: icon) {
                        alert.icon = customIcon
                    }
                } else if let customIcon = NSImage(contentsOfFile: icon) {
                    alert.icon = customIcon
                }
            }
        } else {
            alert.alertStyle = .informational
        }

        NSApp.activate(ignoringOtherApps: true)

        let response = alert.runModal()

        if response == .alertFirstButtonReturn {
            if let urlString = okURL, let url = URL(string: urlString) {
                NSWorkspace.shared.open(url)
            }
            exit(0)
        } else {
            exit(1)
        }
    }

    func playCompletionSound() {
        // Try modern macOS system sounds
        let soundNames = ["Glass", "Pop", "Tink"]

        for soundName in soundNames {
            if let sound = NSSound(named: soundName) {
                sound.play()
                return
            }
        }

        // Fallback to default notification sound
        NSSound.beep()
    }
}

func printUsage() {
    print("""
    Usage: notify [OPTIONS]

    Options:
      --title <text>          Alert title (default: "Notification")
      --description <text>    Alert message/description (default: "")
      --label-ok <text>       Label for OK button (default: "OK")
      --ok-opens-url <url>    URL to open when OK is clicked (optional)
      --icon <type>           Icon type (default: "info")
                              Built-in: info, warning, critical/error
                              SF Symbol: checkmark.circle.fill, gear, etc.
                              Custom: /path/to/image.png
      --help                  Show this help message

    Examples:
      notify --title "Build Complete" --description "Success!" --icon checkmark.circle.fill
      notify --title "Error Occurred" --description "Build failed" --icon critical
      notify --title "Warning" --description "Low disk space" --icon warning
    """)
}

let arguments = CommandLine.arguments

if arguments.contains("--help") {
    printUsage()
    exit(0)
}

let delegate = NotifyDelegate()

for i in 1..<arguments.count {
    switch arguments[i] {
    case "--title":
        if i + 1 < arguments.count {
            delegate.title = arguments[i + 1]
        }
    case "--description":
        if i + 1 < arguments.count {
            delegate.message = arguments[i + 1]
        }
    case "--label-ok":
        if i + 1 < arguments.count {
            delegate.okLabel = arguments[i + 1]
        }
    case "--ok-opens-url":
        if i + 1 < arguments.count {
            delegate.okURL = arguments[i + 1]
        }
    case "--icon":
        if i + 1 < arguments.count {
            delegate.iconType = arguments[i + 1]
        }
    default:
        break
    }
}

let app = NSApplication.shared
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
