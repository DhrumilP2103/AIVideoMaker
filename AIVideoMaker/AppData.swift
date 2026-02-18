import Foundation
import SwiftUI
import Combine

class AppData: ObservableObject {
    static let shared = AppData()
    
    var isLogin: Bool {
        UserDefaults.standard.value(forKey: "bearer_token") as? String ?? "" != ""
    }
    var userhashKey: String {
        UserDefaults.standard.value(forKey: "user_hash_key") as? String ?? ""
    }
    private init() {}  // Prevents others from creating instances
}
