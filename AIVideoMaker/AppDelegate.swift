//
//  AppDelegate.swift
//  Orood
//
//  Created by MB Infoways on 11/09/25.
//

import SwiftUI
import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup IQKeyboardManager
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        return true
    }
}

