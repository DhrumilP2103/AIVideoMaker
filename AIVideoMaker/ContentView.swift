//
//  ContentView.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 04/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appState = NetworkAppState()
    
    var body: some View {
        DashBoardView()
            .environmentObject(appState)
    }
}

#Preview {
    ContentView()
}
