//
//  MovelahApp.swift
//  Movelah
//
//  Created by David Kumar on 12/6/24.
//

import SwiftUI
import Foundation


@main
struct Cleaniy: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
