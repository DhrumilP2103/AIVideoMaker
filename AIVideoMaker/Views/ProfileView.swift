import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: NetworkAppState
    //    @State private var selectedVideo: VideoItem?
    @State private var selectedVideoIndex: Int = 0
    @Namespace private var videoTransition
    
    // Sample user data
    let userName = "John Doe"
    let userEmail = "john.doe@example.com"
    //    let likedVideos: [VideoItem] = VideoItem.sampleData.prefix(6).map { $0 } // Sample liked videos
    
    var body: some View {
        ZStack {
            // Background
//            Color._041_C_32.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Profile Card
                    VStack(spacing: 10) {
                        // Avatar with gradient border
                        ZStack {
                            // Avatar
                            Image("ic_profile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                        }
//                        .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        // User Info
                        VStack(spacing: 4) {
                            Text(userName)
                                .font(Utilities.font(.Bold, size: 22))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 6) {
                                Image("ic_email").resizable().renderingMode(.template)
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text(userEmail)
                                    .font(Utilities.font(.Medium, size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        // Edit Profile Button
                        Button {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            // Navigate to Edit Profile
                            self.router.push(EditProfileView(), route: .editProfileView)
                        } label: {
                            HStack(spacing: 10) {
                                Image("ic_pencil").resizable()
                                    .frame(width: 14, height: 14)
                                
                                Text("Edit Profile")
                                    .font(Utilities.font(.SemiBold, size: 15))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.15),
                                                Color.white.opacity(0.08)
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
                                                        Color.white.opacity(0.3),
                                                        Color.white.opacity(0.1)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(EditButtonStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 24).padding(.top, 20)
                        .padding(.bottom, 30)
                    
                    // Menu Options
                    VStack(spacing: 12) {
                        ProfileMenuOption(
                            icon: "ic_heart_fill",
                            title: "Liked Videos"
                        ) {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            // Navigate to liked videos
                            self.router.push(
                                LikedVideosView()
                                    .environmentObject(appState)
                                ,
                                route: .likedVideosView
                            )
                        }
                        
                        ProfileMenuOption(
                            icon: "ic_settings",
                            title: "Settings"
                        ) {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            // Navigate to settings
                            print("Settings tapped")
                        }
                        
                        ProfileMenuOption(
                            icon: "ic_delete",
                            title: "Delete Account"
                        ) {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            // Show Delete Account Popup
                            appState.popupTitle = "Delete Account"
                            appState.popupMessage = "Are you sure you want to delete your account? This action cannot be undone and all your data will be lost."
                            appState.popupIcon = "ic_delete"
                            appState.popupConfirmTitle = "Delete"
                            appState.popupIsDestructive = true
                            appState.popupAction = {
                                print("Delete Account Confirmed")
                                // TODO: Implement delete account logic
                            }
                            appState.showConfirmationPopup = true
                        }
                        
                        ProfileMenuOption(
                            icon: "ic_logout",
                            title: "Logout"
                        ) {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            // Show Logout Popup
                            appState.popupTitle = "Logout"
                            appState.popupMessage = "Are you sure you want to log out of your account?"
                            appState.popupIcon = "ic_logout"
                            appState.popupConfirmTitle = "Logout"
                            appState.popupIsDestructive = true
                            appState.popupAction = {
                                print("Logout Confirmed")
                                // TODO: Implement logout logic
                            }
                            appState.showConfirmationPopup = true
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
        }
//        .navigationDestination(isPresented: $showLikedVideos) {
//            LikedVideosView()
//                .environmentObject(appState)
//                .toolbar(.hidden)
//        }
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(Utilities.font(.Bold, size: 20))
                .foregroundColor(.white)
            
            Text(title)
                .font(Utilities.font(.Medium, size: 13))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

// MARK: - Profile Menu Option
struct ProfileMenuOption: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon Container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            Color.white.opacity(0.2)
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(icon).resizable()
                        .frame(width: 20, height: 20)
                }
                
                // Title
                Text(title)
                    .font(Utilities.font(.SemiBold, size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(MenuOptionButtonStyle())
    }
}

// MARK: - Menu Option Button Style
struct MenuOptionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Edit Button Style
struct EditButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ProfileView()
}
