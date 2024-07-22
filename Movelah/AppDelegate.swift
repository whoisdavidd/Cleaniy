import Cocoa
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
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
        
        // Request notification permission
        requestNotificationPermission()
        
       
    }

    func createDockMenu() -> NSMenu {
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

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("Permission granted")
                self.scheduleTestNotification()
            } else {
                print("Permission not granted")
            }
        }
    }
    
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Cleaniy"
        content.body = "Notification permission granted!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled")
            }
        }
    }
    
    // Handle notification settings changes
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .sound])
    }
}
