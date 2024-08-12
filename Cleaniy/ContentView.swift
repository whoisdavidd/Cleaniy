import SwiftUI
import Foundation
import AppKit
import UserNotifications




struct ContentView: View {
    @State private var selectedOption: String = "Move"
    @State private var directoryURL: URL?
    @State private var selectedFolder: String = "Documents" // Default folder
    @State private var securityScopedURLs: [URL] = []
    @State private var accessGranted: Bool = false // Track access granted status
    @State private var availableFolders: [String] = []
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
        Button("Allow Desktop Access") {
            requestDesktopAccess { granted in
                if granted {
                    print("Access granted")
                    loadAvailableFolders()
                    accessGranted = true
                } else {
                    print("Access denied")
                }
            }
        }
        .onAppear {
            if let bookmarkData = UserDefaults.standard.data(forKey: "DesktopBookmark") {
                // If access is already granted, resolve the bookmark
                resolveBookmark(bookmarkData)
                accessGranted = true
            } else {
                // If access is not granted, request it
                requestDesktopAccess { granted in
                    if granted, let bookmarkData = UserDefaults.standard.data(forKey: "DesktopBookmark") {
                        resolveBookmark(bookmarkData)
                        accessGranted = true
                    } else {
                        print("Access not granted")
                    }
                }
            }
        }
        .padding()
        .background(MenuView()) // Attach the context menu here
    }
    func resolveBookmark(_ bookmarkData: Data) {
        do {
            var isStale = false
            let securityScopedURL = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            if !isStale, securityScopedURL.startAccessingSecurityScopedResource() {
                defer { securityScopedURL.stopAccessingSecurityScopedResource() }
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: securityScopedURL.path, isDirectory: &isDirectory), isDirectory.boolValue {
                    self.securityScopedURLs.append(securityScopedURL)
                    self.accessGranted = true
                    loadAvailableFolders() // Only load folders once access is confirmed
                } else {
                    print("Resolved URL is not a directory.")
                }
            } else {
                print("Failed to access security-scoped resource or bookmark is stale.")
            }
        } catch {
            print("Error resolving bookmark data: \(error.localizedDescription)")
        }
    }

    
    func loadAvailableFolders() {
        guard let directoryURL = directoryURL else {
            print("Directory URL not set.")
            return
        }

        do {
            // Get a list of all items in the provided directory (Desktop)
            let items = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            // Filter out items that are directories
            let folders = items.filter { $0.hasDirectoryPath }.map { $0.lastPathComponent }
            
            // Update the available folders state
            self.availableFolders = folders
            
            // Automatically select the first folder, if any
            if let firstFolder = folders.first {
                self.selectedFolder = firstFolder
            }
        } catch {
            print("Error loading folders on desktop: \(error)")
        }
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
            
            // Iterate through the files and delete only the screenshots
            for file in filesInSourceDir {
                let filePath = sourceDir.appendingPathComponent(file)
                
                // Check if the file name matches the screenshot naming convention
                if file.lowercased().hasPrefix("screen shot") {
                            var moved = false
                                do {
                                    try NSWorkspace.shared.recycle([filePath])
                                    moved = true
                                } catch {
                                    print("Error moving screenshot \(file) to Trash: \(error)")
                                }
                                
                                if moved {
                                    print("Moved screenshot \(file) to Trash.")
                                } else {
                                    print("Failed to move screenshot \(file) to Trash.")
                                }
                            }
            }
        } catch {
            print("Error reading contents of directory: \(error)")
        }
    }

    func requestDesktopAccess(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let openPanel = NSOpenPanel()
            openPanel.message = "Please grant access to the Desktop directory."
            openPanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
            openPanel.canChooseDirectories = true
            openPanel.canChooseFiles = false
            openPanel.allowsMultipleSelection = false
            openPanel.prompt = "Grant Access"
            
            openPanel.begin { response in
                if response == .OK, let url = openPanel.url {
                    do {
                        let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                        UserDefaults.standard.set(bookmark, forKey: "DesktopBookmark")
                        _ = url.startAccessingSecurityScopedResource()
                        
                        self.directoryURL = url // Store the URL here
                        completion(true)
                    } catch {
                        print("Error creating bookmark: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    completion(false)
                }
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
