//
//  ContextMenuManager.swift
//  Movelah
//
//  Created by David Kumar on 20/7/24.
//

import AppKit
import SwiftUI

class ContextMenuManager: NSObject {
    @objc func deleteAction() {
        // Implement your delete action
        print("Delete action triggered")
    }
    
    @objc func moveAction() {
        // Implement your move action
        print("Move action triggered")
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        let deleteMenuItem = NSMenuItem(title: "Delete", action: #selector(deleteAction), keyEquivalent: "")
        deleteMenuItem.target = self
        menu.addItem(deleteMenuItem)
        
        let moveMenuItem = NSMenuItem(title: "Move", action: #selector(moveAction), keyEquivalent: "")
        moveMenuItem.target = self
        menu.addItem(moveMenuItem)
        
        return menu
    }
}
