//
//  Utilities.swift
//  OYaar
//
//  Created by MB Infoways on 02/08/23.
//

import Foundation
import SwiftUI
import UIKit

// MARK: Current Class - Utilities
//********************************************************************************************//
class Utilities: NSObject {
    
    struct fontName {
        // Lexend
        static let bold = "Poppins-Bold"
        static let semiBold = "Poppins-SemiBold"
        static let medium = "Poppins-Medium"
        static let regular = "Poppins-Regular"
    }
    
    class func font(_ type: AppFont, size: CGFloat) -> Font {
        return type.withSize(fontSize: size)
    }
    
    static func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    static func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    func delay(delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

enum AppFont {
    // Lexend
    case Bold
    case SemiBold
    case Medium
    case Regular
    
    func withSize(fontSize: CGFloat) -> Font {
        switch self {
            // Lexend
        case .Bold:
            return Font.custom(Utilities.fontName.bold, size: fontSize)
        case .SemiBold:
            return Font.custom(Utilities.fontName.semiBold, size: fontSize)
        case .Medium:
            return Font.custom(Utilities.fontName.medium, size: fontSize)
        case .Regular:
            return Font.custom(Utilities.fontName.regular, size: fontSize)
        }
    }
}

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(
        ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(
        ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    
    static let IS_IPHONE_5 =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_SE =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    
    static let IS_IPHONE_6S =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6 =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7 =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_8 =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    
    static let IS_IPHONE_6P =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_6S_P =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_7P =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_8P =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    
    static let IS_IPHONE_X =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH >= 812.0
    static let IS_IPHONE_XS =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_11Pro =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    
    static let IS_IPHONE_XR =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_11 =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_11Pro_MAX =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_XS_MAX =
    UIDevice.current.userInterfaceIdiom == .phone
    && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    
    static let IS_IPAD =
    UIDevice.current.userInterfaceIdiom == .pad
    && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO =
    UIDevice.current.userInterfaceIdiom == .pad
    && ScreenSize.SCREEN_MAX_LENGTH > 1024.0
    static let IS_IPAD_PRO10_5 =
    UIDevice.current.userInterfaceIdiom == .pad
    && ScreenSize.SCREEN_MAX_LENGTH == 1112.0
    static let IS_IPAD_MINI =
    UIDevice.current.userInterfaceIdiom == .pad
    && ScreenSize.SCREEN_MAX_LENGTH == 768.0
    
}
