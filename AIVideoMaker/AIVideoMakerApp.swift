//
//  AIVideoMakerApp.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 04/02/26.
//

import SwiftUI

@main
struct AIVideoMakerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var router = Router()
    var body: some Scene {
        WindowGroup {
            NavigationControllerRootView(router: router)
                .environmentObject(router)
                .ignoresSafeArea(.all)
        }
    }
}
