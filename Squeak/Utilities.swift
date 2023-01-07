//
//  Utilities.swift
//  Squeak
//
//  Created by Josh Boys on 7/1/2023.
//

import SwiftUI


@discardableResult
func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var this = item
    try update(&this)
    return this
}


enum SqueakApp {
    static let name = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
        
    @MainActor
    static func quit() {
        NSApp.terminate(nil)
    }
}
