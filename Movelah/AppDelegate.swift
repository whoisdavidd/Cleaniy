import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the main application window
        let contentView = ContentView()
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu()
        
        let deleteMenuItem = NSMenuItem(title: "Delete", action: #selector(deleteAction), keyEquivalent: "")
        deleteMenuItem.target = self
        menu.addItem(deleteMenuItem)
        
        let moveMenuItem = NSMenuItem(title: "Move", action: #selector(moveAction), keyEquivalent: "")
        moveMenuItem.target = self
        menu.addItem(moveMenuItem)
        
        return menu
    }

    @objc func deleteAction() {
        // Implement your delete action
        print("Delete action triggered from Dock menu")
    }
    
    @objc func moveAction() {
        // Implement your move action
        print("Move action triggered from Dock menu")
    }
}
