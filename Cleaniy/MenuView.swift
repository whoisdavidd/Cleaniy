//
//  MenuView.swift
//  Movelah
//
//  Created by David Kumar on 20/7/24.
//

import SwiftUI
import AppKit

struct MenuView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        let menuManager = ContextMenuManager()
        view.menu = menuManager.createMenu()
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Update the view if needed
    }
}
