import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    // Form States
    @State private var firstName: String = "John"
    @State private var lastName: String = "Doe"
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceSelection = false
    
    
    var body: some View {
        ZStack {
            // Background
            Color._041_C_32.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    // Back Button
                    Button {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
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
                                    } else {
                                        Image("ic_profile")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 116, height: 116)
                                            .clipShape(Circle())
                                    }
                                }
                                .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
                                
                                // Edit Image Button
                                Button {
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                    showSourceSelection = true
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(Color._041_C_32, lineWidth: 3)
                                    )
                                }
                            }
                            
                            Text("Tap to change photo")
                                .font(Utilities.font(.Medium, size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 10)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // First Name Field
                            ProfileInputField(
                                title: "First Name",
                                placeholder: "Enter first name",
                                text: $firstName,
                                icon: "person.fill"
                            )
                            
                            // Last Name Field
                            ProfileInputField(
                                title: "Last Name",
                                placeholder: "Enter last name",
                                text: $lastName,
                                icon: "person.fill"
                            )
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
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                
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
                            .shadow(color: Color(hex: "667eea").opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                        .buttonStyle(SaveButtonStyle())
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if showSourceSelection {
                ImageSourcePickerPopup(
                    isPresented: $showSourceSelection,
                    onCameraSelected: {
                        imagePickerSource = .camera
                        showImagePicker = true
                    },
                    onGallerySelected: {
                        imagePickerSource = .photoLibrary
                        showImagePicker = true
                    }
                )
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                sourceType: imagePickerSource,
                selectedImage: $selectedImage
            )
        }
    }
    
    private func saveProfile() {
        // TODO: Implement profile save logic
        print("Saving profile:")
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        print("Image: \(selectedImage != nil ? "Updated" : "No change")")
        
        // Dismiss after save
        dismiss()
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
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isFocused ? Color(hex: "667eea") : .white.opacity(0.5))
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
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isFocused ? 0.12 : 0.08),
                                Color.white.opacity(isFocused ? 0.08 : 0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        isFocused ? Color(hex: "667eea").opacity(0.5) : Color.white.opacity(0.2),
                                        isFocused ? Color(hex: "764ba2").opacity(0.5) : Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isFocused ? 1.5 : 1
                            )
                    )
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
    }
}

// MARK: - Picker Button Style
struct PickerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Save Button Style
struct SaveButtonStyle: ButtonStyle {
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
