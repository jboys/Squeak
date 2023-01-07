//
//  Squeak.swift
//  Squeak
//
//  Created by Josh Boys on 7/1/2023.
//

import SwiftUI


extension Notification.Name {
    static let swipeScrollDirectionDidChangeNotification = Notification.Name(rawValue: "SwipeScrollDirectionDidChangeNotification")
}


class Squeak {
    static let shared = Squeak()
    private var lastDeviceID: Int?
    private var lastDeviceType: DeviceType?
    
    init() {
        lastDeviceID = nil
        NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel, handler: scrollWheelHandler)
    }
    
    public func getDeviceType() -> DeviceType? {
        return lastDeviceType
    }
    
    private func scrollWheelHandler(event: NSEvent) {
        if lastDeviceID == nil || event.deviceID != lastDeviceID {
            lastDeviceID = event.deviceID
            if event.subtype == .mouseEvent {
                lastDeviceType = .mouse
                setDirection(.normal)
            } else {
                lastDeviceType = .trackpad
                setDirection(.natural)
            }
            DispatchQueue.main.async {
                AppState.shared.updateIcon()
            }
        }
    }
    
    private func setDirection(_ new: Direction) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/defaults")
        
        let newValue = new == .normal ? "NO": "YES"
        process.arguments = ["write", "-g", "com.apple.swipescrolldirection", "-bool", newValue]
        
        do {
            try process.run()
            process.waitUntilExit()
            DistributedNotificationCenter.default().postNotificationName(
                .swipeScrollDirectionDidChangeNotification,
                object: nil,
                userInfo: nil,
                deliverImmediately: false)
            setSwipeScrollDirection(new == .natural)
        } catch {
            print(error)
        }
    }
}

enum Direction: String {
    case normal
    case natural
}

enum DeviceType: String {
    case mouse
    case trackpad
}
