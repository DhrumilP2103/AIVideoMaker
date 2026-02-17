import SwiftUI
import Photos
import AVFoundation
import Combine

// MARK: - Permission Strings
/// A centralized struct to hold all permission-related strings.
/// Helps to avoid hardcoding and makes localization easier.
struct PermissionConstants {
    // Permission Titles
    static let photoLibraryTitle = "Photo Library Permission Required"
    static let cameraTitle = "Camera Permission Required"
    
    // Permission Messages
    static let photoLibraryMessage = "Please allow access to Photo Library in Settings to select photos."
    static let cameraMessage = "Please allow access to Camera in Settings to take photos."
    
    // Generic messages
    static let accessGranted = "Access Granted"
    static let accessDenied = "Access Denied"
    static let unknownStatus = "Unknown authorization status"
}

// MARK: - Permission Manager
/// A singleton class to handle permissions for Camera and Photo Library.
/// Uses `ObservableObject` so SwiftUI views can observe changes for alerts.
class PermissionManager: ObservableObject {
    static let shared = PermissionManager()
    
    // MARK: - Published Properties for Alert
    @Published var showAlert = false             // Controls showing of alert
    @Published var alertTitle = ""              // Alert title
    @Published var alertMessage = ""            // Alert message
    @Published var settingsURL: URL?            // URL to open app settings
    
    // Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Request Photo Library Access
    /// Requests access to the photo library.
    /// - Parameter authorized: Closure returning (Bool, String) indicating whether access is granted and a message.
    func requestPhotoLibraryAccess(authorized: @escaping (Bool, String) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            // User has not been asked yet, request access
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        // Access granted
                        print(PermissionConstants.accessGranted)
                        authorized(true, PermissionConstants.accessGranted)
                    } else {
                        // Access denied, show alert
                        self.showPermissionAlert(
                            title: PermissionConstants.photoLibraryTitle,
                            message: PermissionConstants.photoLibraryMessage
                        )
                        authorized(false, PermissionConstants.accessDenied)
                    }
                }
            }
        case .restricted, .denied:
            // Access is denied or restricted, show alert
            self.showPermissionAlert(
                title: PermissionConstants.photoLibraryTitle,
                message: PermissionConstants.photoLibraryMessage
            )
            authorized(false, PermissionConstants.accessDenied)
        case .authorized, .limited:
            // Already granted
            print(PermissionConstants.accessGranted)
            authorized(true, PermissionConstants.accessGranted)
        @unknown default:
            // Handle future unknown cases
            print(PermissionConstants.unknownStatus)
            authorized(false, PermissionConstants.unknownStatus)
        }
    }
    
    // MARK: - Request Camera Access
    /// Requests access to the device camera.
    /// - Parameter authorized: Closure returning (Bool, String) indicating whether access is granted and a message.
    func requestCameraAccess(authorized: @escaping (Bool, String) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            // User has not been asked yet, request access
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        // Access granted
                        print(PermissionConstants.accessGranted)
                        authorized(true, PermissionConstants.accessGranted)
                    } else {
                        // Access denied, show alert
                        self.showPermissionAlert(
                            title: PermissionConstants.cameraTitle,
                            message: PermissionConstants.cameraMessage
                        )
                        authorized(false, PermissionConstants.accessDenied)
                    }
                }
            }
        case .restricted, .denied:
            // Access is denied or restricted, show alert
            self.showPermissionAlert(
                title: PermissionConstants.cameraTitle,
                message: PermissionConstants.cameraMessage
            )
            authorized(false, PermissionConstants.accessDenied)
        case .authorized:
            // Already granted
            print(PermissionConstants.accessGranted)
            authorized(true, PermissionConstants.accessGranted)
        @unknown default:
            // Handle future unknown cases
            print(PermissionConstants.unknownStatus)
            authorized(false, PermissionConstants.unknownStatus)
        }
    }
    
    // MARK: - Show Permission Alert
    /// Updates published properties to show an alert in SwiftUI.
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    private func showPermissionAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        settingsURL = URL(string: UIApplication.openSettingsURLString)
        showAlert = true
    }
}
