import SwiftUI
import Foundation
import AppKit
import UserNotifications

// Entitlement Keys:
// Entitlement Keys:
// 1. com.apple.security.assets.movies.read-write: Allows the app to read and write to the user's Movies directory.
// 2. com.apple.security.assets.music.read-write: Allows the app to read and write to the user's Music directory.
// 3. com.apple.security.assets.pictures.read-write: Allows the app to read and write to the user's Pictures directory.
// 4. com.apple.security.files.downloads.read-write: Allows the app to read and write to the user's Downloads directory.
// 5. com.apple.security.files.user-selected.read-write: Allows the app to read and write to user-selected files and folders.I need this entitlement key because my app requires permission from users so that they can go to the desktop delete the screenshots and move the screenshots to their designated folder that they want.I need The actual entitlement key com.apple.security.files.user-selected.read-write.If I can't have it, please advise me on what entitlements I should substitute it with.
// 6. App Sandbox: Enables sandboxing, restricting the app's access to system resources and user data for security purposes.


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
    
    func handleAction(action: DesktopAction, sourceDirectory: URL? = nil, destinationDirectory: URL? = nil) {
        if accessGranted {
            performAction(action: action, sourceDirectory: sourceDirectory, destinationDirectory: destinationDirectory)
        } else {
            requestDesktopAccess { granted in
                if granted {
                    self.accessGranted = true
                    performAction(action: action, sourceDirectory: sourceDirectory, destinationDirectory: destinationDirectory)
                }
            }
        }
    }
    
    func performAction(action: DesktopAction, sourceDirectory: URL? = nil, destinationDirectory: URL? = nil) {
        switch action {
        case .move:
            moveItemsToFolder(folder: selectedFolder, sourceDirectory: sourceDirectory, destinationDirectory: destinationDirectory)
            sendNotification(message: "Cleaniy has moved your items yay!")
        case .delete:
            deleteItemsOnDesktop(sourceDirectory: sourceDirectory)
            sendNotification(message: "Cleaniy has cleaned your desktop yay!")
        }
        self.presentationMode.wrappedValue.dismiss() // Dismiss view after action
    }
    
    func moveItemsToFolder(folder: String, sourceDirectory: URL? = nil, destinationDirectory: URL? = nil) {
        let sourceDir = sourceDirectory ?? FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")
        let destinationDir = destinationDirectory ?? FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(folder)
        
        // Ensure the destination folder exists
        if !FileManager.default.fileExists(atPath: destinationDir.path) {
            do {
                try FileManager.default.createDirectory(at: destinationDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating destination folder: \(error)")
                return
            }
        }
        
        do {
            // Get a list of all files in the source directory
            let filesInSourceDir = try FileManager.default.contentsOfDirectory(atPath: sourceDir.path)
            
            // Iterate through the files and move them to the destination folder
            for file in filesInSourceDir {
                let src = sourceDir.appendingPathComponent(file)
                let dst = destinationDir.appendingPathComponent(file)
                
                do {
                    // Check if the file is a directory
                    var isDirectory: ObjCBool = false
                    FileManager.default.fileExists(atPath: src.path, isDirectory: &isDirectory)
                    
                    if !isDirectory.boolValue {
                        // Move the file if it's not a directory
                        try FileManager.default.moveItem(at: src, to: dst)
                        print("Moved \(file) to \(destinationDir.path).")
                    }
                } catch {
                    print("Error moving file \(file): \(error)")
                }
            }
        } catch {
            print("Error reading contents of source directory: \(error)")
        }
    }
    
    func deleteItemsOnDesktop(sourceDirectory: URL? = nil) {
        let sourceDir = sourceDirectory ?? FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")
        
        do {
            // Get a list of all files in the source directory
            let filesInSourceDir = try FileManager.default.contentsOfDirectory(atPath: sourceDir.path)
            
            // Iterate through the files and delete them
            for file in filesInSourceDir {
                let filePath = sourceDir.appendingPathComponent(file)
                do {
                    try FileManager.default.removeItem(at: filePath)
                    print("Deleted \(file) from directory.")
                } catch {
                    print("Error deleting file \(file): \(error)")
                }
            }
        } catch {
            print("Error reading contents of directory: \(error)")
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
