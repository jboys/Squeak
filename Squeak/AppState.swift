//
//  AppState.swift
//  Squeak
//
//  Created by Josh Boys on 7/1/2023.
//

import SwiftUI

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()
    
    init() {
        DispatchQueue.main.async { [self] in
            createMenuBarUI()
        }
    }
    
    func updateIcon() {
        guard let button = statusItem.button else { return }
        
        let deviceType = Squeak.shared.getDeviceType()
        
        var iconName: String!
        
        if deviceType == .mouse {
            iconName = "computermouse"
        } else if deviceType == .trackpad {
            iconName = "rectangle"
        } else {
            iconName = "rectangle.dashed"
        }
        
        button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil)
    }
    
    private(set) lazy var statusItem = with(NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)) {
        $0.isVisible = false
    }
    
    private func createMenuBarUI() {
        updateIcon()
        createMenu()
        statusItem.isVisible = true
    }
    
    private func createMenu() {
        statusItem.menu = NSMenu()
        addQuitItem()
    }
    
    private func addQuitItem() {
        guard let menu = statusItem.menu else { return }
        
        let menuItem = NSMenuItem()
        menuItem.title = "Quit \(SqueakApp.name)"
        menuItem.action = #selector(quit)
        menuItem.target = self
        menuItem.keyEquivalent = "q"
        
        menu.addItem(menuItem)
    }
    
    @objc private func quit() {
        SqueakApp.quit()
    }
}
