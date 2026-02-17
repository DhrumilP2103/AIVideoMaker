import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appState: NetworkAppState
    @StateObject var viewModel = ProfileViewModel()
    
    // Permission Manager
    @StateObject private var permissionManager = PermissionManager.shared
    
    
    // Form States
    @State private var name: String = ""
    //    @State private var lastName: String = "Doe"
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceSelection = false
    
    @State private var showProfilePreview = false
    
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color._041_C_32,
                    Color(hex: "064663")
                ],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    // Back Button
                    Button {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        dismiss()
                    } label: {
                        Image("ic_back").resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(.white.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(Utilities.font(.Bold, size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Profile Image Section
                        VStack(spacing: 16) {
                            
                            Button {
                                self.showProfilePreview = true
//                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
//                                impactFeedback.impactOccurred()
//                                showSourceSelection = true
                            } label: {
                                ZStack(alignment: .bottomTrailing) {
                                    // Avatar with gradient border
                                    ZStack {
                                        // Avatar
                                        if let selectedImage = selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 116, height: 116)
                                                .clipShape(Circle())
                                        } else if self.viewModel.profileResponseData.profileImage != "" {
                                            UrlImageView(
                                                imageURL: URL(string: self.viewModel.profileResponseData.profileImage ?? ""),
                                                width: 116, height: 116,
                                                cornerRadius: 58
                                            )
                                        } else {
                                            Image("ic_profile")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 116, height: 116)
                                                .clipShape(Circle())
                                        }
                                    }
                                    
                                    // Edit Image Button
//                                    ZStack {
//                                        Circle()
//                                            .fill(
//                                                LinearGradient(
//                                                    colors: [
//                                                        Color(hex: "667eea"),
//                                                        Color(hex: "764ba2")
//                                                    ],
//                                                    startPoint: .topLeading,
//                                                    endPoint: .bottomTrailing
//                                                )
//                                            )
//                                            .frame(width: 36, height: 36)
//                                        
//                                        Image("ic_camera").resizable()
//                                            .frame(width: 16, height: 16)
//                                            .foregroundColor(.white)
//                                    }
//                                    .overlay(
//                                        Circle()
//                                            .stroke(Color._041_C_32, lineWidth: 3)
//                                    )
                                }
                            }
//                            Text("Tap to change photo")
//                                .font(Utilities.font(.Medium, size: 14))
//                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 10)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // First Name Field
                            ProfileInputField(
                                title: "Name",
                                placeholder: "Enter name",
                                text: $name,
                                icon: "ic_person"
                            )
                            
                            // Last Name Field
//                            ProfileInputField(
//                                title: "Last Name",
//                                placeholder: "Enter last name",
//                                text: $lastName,
//                                icon: "ic_person"
//                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Save Button
                        Button {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            // Save profile changes
                            saveProfile()
                        } label: {
                            HStack(spacing: 12) {
                                Text("Save Changes")
                                    .font(Utilities.font(.Bold, size: 16))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: "667eea"),
                                                Color(hex: "764ba2")
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        }
                        .buttonStyle(BtnStyle())
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear() {
            self.name = self.viewModel.profileResponseData.name ?? ""
        }
        .networkStatusPopups(viewModel: viewModel)
        .onChange(of: appState.retryRequestedForAPI) { _, apiName in
            guard let name = apiName else { return }
            if checkInternet() {
                withAnimation {
                    appState.isNoInternet = false
                    if let retry = viewModel.retryAPIs[name] {
                        retry()
                        appState.retryRequestedForAPI = nil
                    }
                }
            }
        }
        .fullScreenCover(isPresented: self.$showProfilePreview) {
            ImageViewerRemote(imageURL: .constant(self.viewModel.profileResponseData.profileImage ?? ""), viewerShown: self.$showProfilePreview, isShowCloseButton: true)
        }
        .onChange(of: viewModel.profileUpdateSuccess) { _, success in
            if success {
                viewModel.profileUpdateSuccess = false
                dismiss()
            }
        }
        .overlay {
            if self.showSourceSelection {
                ImageSourcePickerPopup(
                    isPresented: $showSourceSelection,
                    onCameraSelected: {
                        // Request camera permission before showing picker
                        permissionManager.requestCameraAccess { granted, message in
                            if granted {
                                self.imagePickerSource = .camera
                                self.showImagePicker = true
                            }
                        }
                    },
                    onGallerySelected: {
                        // Request photo library permission before showing picker
                        permissionManager.requestPhotoLibraryAccess { granted, message in
                            if granted {
                                self.imagePickerSource = .photoLibrary
                                self.showImagePicker = true
                            }
                        }
                    }
                )
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                sourceType: self.imagePickerSource,
                selectedImage: $selectedImage
            )
        }
        .alert(permissionManager.alertTitle, isPresented: $permissionManager.showAlert) {
            Button("Cancel", role: .cancel) { }
            if let url = permissionManager.settingsURL {
                Button("Settings") {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(permissionManager.alertMessage)
        }
    }
    
    
    private func saveProfile() {
        // Validate name is not empty
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            DEBUGLOG("Name cannot be empty")
            return
        }
        
        // Get current email from profile data
        let email = viewModel.profileResponseData.email ?? ""
        
        // Call update profile API
        self.viewModel.name = self.name
        self.viewModel.updateProfile(appState: appState)
        
    }
}

// MARK: - Profile Input Field
struct ProfileInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Field Title
            Text(title)
                .font(Utilities.font(.SemiBold, size: 14))
                .foregroundColor(.white.opacity(0.8))
            
            // Input Field
            HStack(spacing: 14) {
                // Icon
                Image(icon).resizable().renderingMode(.template)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 24)
                
                // Text Field
                TextField(placeholder, text: $text)
                    .font(Utilities.font(.Medium, size: 16))
                    .foregroundColor(.white)
                    .focused($isFocused)
                    .tint(Color(hex: "667eea"))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        Color.white.opacity(0.08)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
    }
}
// MARK: - Save Button Style
struct BtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}


#Preview {
    EditProfileView()
}
