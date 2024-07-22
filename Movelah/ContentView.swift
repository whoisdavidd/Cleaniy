import SwiftUI
import Foundation
import AppKit
import UserNotifications

struct ContentView: View {
    @State private var selectedOption: String = "Move"
    @State private var selectedFolder: String = "Documents" // Default folder
    @State private var securityScopedURLs: [URL] = []
    @State private var accessGranted: Bool = false // Track access granted status
    let availableFolders = ["Documents", "Downloads", "Pictures", "Music", "Movies"] // Predefined folders
    @Environment(\.presentationMode) var presentationMode // Environment property to manage presentation mode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 3.0) {
                Text("Cleaniy!")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                    .padding()
                    .bold()
                    .italic()
                Spacer()
            }
            Divider()
            // Uncomment this section for Advanced Settings
            /*
            VStack(spacing: 20) {
                Button(action: {
                    // Action for Advanced Settings button
                }) {
                    Text("Advanced Settings")
                        .foregroundColor(.black)
                        .padding(2.0)
                        .background(Color.white)
                        .cornerRadius(6)
                }
            }
            */
            Divider()
            HStack {
                Text("Move or delete the unassigned items on your desktop?")
                    .padding(0.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("", selection: $selectedOption) {
                    Text("Move").tag("Move")
                    Text("Delete").tag("Delete")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 195.0)
            }
            .padding()
            
            if selectedOption == "Delete" {
                HStack {
                    Spacer()
                    Button(action: {
                        handleAction(action: .delete)
                    }) {
                        Text("Confirm")
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        print("Delete action cancelled")
                        self.presentationMode.wrappedValue.dismiss() // Dismiss view on cancel
                    }) {
                        Text("Cancel")
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
                Text("We are deleting whatever items on the desktop to make it clutter free")
                    .padding(.vertical, 20)
                Spacer()  // Add Spacer here to push content to the top when Delete is selected
            } else {
                VStack(alignment: .leading) {
                    Text("Do you have any specific folder you want me to put?")
                        .padding(0.0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Select Folder", selection: $selectedFolder) {
                        ForEach(availableFolders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            handleAction(action: .move)
                        }) {
                            Text("Confirm")
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        Button(action: {
                            print("Move action cancelled")
                            self.presentationMode.wrappedValue.dismiss() // Dismiss view on cancel
                        }) {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            // Check if access is already granted using UserDefaults
            if UserDefaults.standard.bool(forKey: "DesktopAccessGranted"), let bookmarkData = UserDefaults.standard.data(forKey: "DesktopBookmark") {
                do {
                    var isStale = false
                    let securityScopedURL = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                    
                    if !isStale {
                        _ = securityScopedURL.startAccessingSecurityScopedResource()
                        self.securityScopedURLs.append(securityScopedURL)
                        self.accessGranted = true
                    }
                } catch {
                    print("Error resolving bookmark data: \(error.localizedDescription)")
                }
            }
        }
        .padding()
        .background(MenuView()) // Attach the context menu here
    }
    
    func handleAction(action: DesktopAction) {
        if accessGranted {
            performAction(action: action)
        } else {
            requestDesktopAccess { granted in
                if granted {
                    self.accessGranted = true
                    performAction(action: action)
                }
            }
        }
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }
    }
    
    func performAction(action: DesktopAction) {
        switch action {
        case .move:
            moveItemsToFolder(folder: selectedFolder)
            sendNotification(message: "Cleaniy has moved your items yay!")
        case .delete:
            deleteItemsOnDesktop()
            sendNotification(message: "Cleaniy has cleaned your desktop yay!")
        }
        self.presentationMode.wrappedValue.dismiss() // Dismiss view after action
    }
    
    func moveItemsToFolder(folder: String) {
        let desktopPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")
        let destinationFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(folder)
        
        // Ensure the destination folder exists
        if !FileManager.default.fileExists(atPath: destinationFolder.path) {
            do {
                try FileManager.default.createDirectory(at: destinationFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating destination folder: \(error)")
                return
            }
        }
        
        do {
            // Get a list of all files on the desktop
            let filesOnDesktop = try FileManager.default.contentsOfDirectory(atPath: desktopPath.path)
            
            // Iterate through the files and move them to the destination folder
            for file in filesOnDesktop {
                let src = desktopPath.appendingPathComponent(file)
                let dst = destinationFolder.appendingPathComponent(file)
                
                do {
                    // Check if the file is a directory
                    var isDirectory: ObjCBool = false
                    FileManager.default.fileExists(atPath: src.path, isDirectory: &isDirectory)
                    
                    if !isDirectory.boolValue {
                        // Move the file if it's not a directory
                        try FileManager.default.moveItem(at: src, to: dst)
                        print("Moved \(file) to \(destinationFolder.path).")
                    }
                } catch {
                    print("Error moving file \(file): \(error)")
                }
            }
        } catch {
            print("Error reading contents of desktop: \(error)")
        }
    }
    
    func requestDesktopAccess(completion: @escaping (Bool) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.message = "Please grant access to the Desktop directory."
        openPanel.directoryURL = URL(fileURLWithPath: NSHomeDirectory() + "/Desktop")
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.prompt = "Grant Access"
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                do {
                    let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    var isStale = false
                    let securityScopedURL = try URL(resolvingBookmarkData: bookmark, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                    
                    if !isStale {
                        _ = securityScopedURL.startAccessingSecurityScopedResource()
                        self.securityScopedURLs.append(securityScopedURL)
                        UserDefaults.standard.set(true, forKey: "DesktopAccessGranted") // Save access status
                        UserDefaults.standard.set(bookmark, forKey: "DesktopBookmark") // Save bookmark
                        completion(true)
                    } else {
                        print("Bookmark data is stale")
                        completion(false)
                    }
                } catch {
                    print("Error creating bookmark or resolving URL: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func deleteItemsOnDesktop() {
        let desktopPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")
        
        do {
            // Get a list of all files on the desktop
            let filesOnDesktop = try FileManager.default.contentsOfDirectory(atPath: desktopPath.path)
            
            // Iterate through the files and delete screenshots from the desktop
            for file in filesOnDesktop {
                if file.hasPrefix("Screenshot") || file.hasPrefix("Screen Shot") {
                    let filePath = desktopPath.appendingPathComponent(file)
                    do {
                        try FileManager.default.removeItem(at: filePath)
                        print("Deleted \(file) from desktop.")
                    } catch {
                        print("Error deleting file \(file): \(error)")
                    }
                }
            }
        } catch {
            print("Error reading contents of desktop: \(error)")
        }
    }
    
    func sendNotification(message: String) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification permission: \(error.localizedDescription)")
                    return
                }
                
                if granted {
                    print("Permission granted")
                    
                    // Create the notification content
                    let notification = UNMutableNotificationContent()
                    notification.title = "Cleaniy"
                    notification.body = message
                    notification.sound = UNNotificationSound.default
                    
                    // Create a trigger to fire the notification after 2 seconds
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                    
                    // Create the notification request
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
                    
                    // Add the notification request to the notification center
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error adding notification: \(error.localizedDescription)")
                        } else {
                            print("Notification scheduled: \(message)")
                        }
                    }
                } else {
                    print("Permission not granted")
                }
            }
    }
    
    enum DesktopAction {
        case move
        case delete
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
