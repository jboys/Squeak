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
    
    init() {
        lastDeviceID = nil
        NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel, handler: scrollWheelHandler)
    }
    
    private func scrollWheelHandler(event: NSEvent) {
        if lastDeviceID == nil || event.deviceID != lastDeviceID {
            lastDeviceID = event.deviceID
            if event.subtype == .mouseEvent {
                print("Changed to mouse -- setting scroll to normal")
                setDirection(.normal)
            } else {
                print("Changed to trackpad -- setting scroll to natural")
                setDirection(.natural)
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
