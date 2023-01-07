//
//  ContentView.swift
//  Squeak
//
//  Created by Josh Boys on 7/1/2023.
//

import SwiftUI

struct ContentView: View {
    let squeak = Squeak.shared
    
    var body: some View {
        VStack {
            Text("Squeak!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
