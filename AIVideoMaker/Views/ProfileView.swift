import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
//    @State private var selectedVideo: VideoItem?
    @State private var selectedVideoIndex: Int = 0
    @State private var isNavForDetail: Bool = false
    @Namespace private var videoTransition
    
    // Sample user data
    let userName = "John Doe"
    let userEmail = "john.doe@example.com"
//    let likedVideos: [VideoItem] = VideoItem.sampleData.prefix(6).map { $0 } // Sample liked videos
    
    var body: some View {
        ZStack {
            // Background
            Color._041_C_32.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header with close button
//                    HStack {
//                        Text("Profile")
//                            .font(Utilities.font(.Bold, size: 28))
//                            .foregroundColor(.white)
//                        
//                        Spacer()
//                        
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.title3)
//                                .foregroundColor(.white.opacity(0.7))
//                                .padding(10)
//                                .background(.white.opacity(0.1))
//                                .clipShape(Circle())
//                        }
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.top, 60)
//                    .padding(.bottom, 20)
//                    
                    // Profile Card
                    VStack(spacing: 20) {
                        // Avatar with gradient border
                        ZStack {
                            // Gradient border
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.purple, .pink, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 124, height: 124)
                            
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .frame(width: 116, height: 116)
                        }
                        .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        // User Info
                        VStack(spacing: 8) {
                            Text(userName)
                                .font(Utilities.font(.Bold, size: 24))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text(userEmail)
                                    .font(Utilities.font(.Medium, size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        // Edit Profile Button
                        Button {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            // Edit profile action
                            print("Edit Profile tapped")
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .semibold))
                                
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
                        .padding(.top, 16)
                        
                        // Stats Row
//                        HStack(spacing: 40) {
//                            StatItem(title: "Videos", value: "12")
//                            StatItem(title: "Likes", value: "\(likedVideos.count)")
//                            StatItem(title: "Following", value: "24")
//                        }
//                        .padding(.top, 10)
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
                    
                    // Liked Videos Section
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Image(systemName: "heart.fill")
//                                .font(.system(size: 18))
//                                .foregroundColor(.pink)
//                            
//                            Text("Liked Videos")
//                                .font(Utilities.font(.Bold, size: 22))
//                                .foregroundColor(.white)
//                            
//                            Spacer()
//                            
//                            Text("\(likedVideos.count)")
//                                .font(Utilities.font(.Bold, size: 14))
//                                .foregroundColor(.white.opacity(0.5))
//                                .padding(.horizontal, 12)
//                                .padding(.vertical, 6)
//                                .background(
//                                    Capsule()
//                                        .fill(.white.opacity(0.1))
//                                )
//                        }
//                        .padding(.horizontal, 24)
//                        
//                        if likedVideos.isEmpty {
//                            // Empty state
//                            VStack(spacing: 12) {
//                                Image(systemName: "heart.slash")
//                                    .font(.system(size: 50))
//                                    .foregroundColor(.white.opacity(0.3))
//                                
//                                Text("No liked videos yet")
//                                    .font(Utilities.font(.Medium, size: 16))
//                                    .foregroundColor(.white.opacity(0.5))
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 60)
//                        } else {
//                            // Videos Grid
//                            LazyVGrid(columns: [
//                                GridItem(.flexible(), spacing: 15),
//                                GridItem(.flexible(), spacing: 15)
//                            ], spacing: 15) {
//                                ForEach(Array(likedVideos.enumerated()), id: \.element.id) { index, video in
//                                    LikedVideoCard(video: video)
//                                        .matchedGeometryEffect(id: video.id.uuidString, in: videoTransition)
//                                        .onTapGesture {
//                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                                                selectedVideo = video
//                                                selectedVideoIndex = index
//                                                isNavForDetail = true
//                                            }
//                                        }
//                                }
//                            }
//                            .padding(.horizontal, 24)
//                        }
//                    }
//                    .padding(.bottom, 100)
                }
            }
        }
//        .navigationDestination(isPresented: $isNavForDetail) {
//            if selectedVideo != nil {
//                VideoReelsView(
//                    videos: likedVideos,
//                    startIndex: selectedVideoIndex,
//                    animation: videoTransition,
//                    isNavForDetail: $isNavForDetail
//                )
//                .navigationBarHidden(true)
//            }
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

// MARK: - Liked Video Card
//struct LikedVideoCard: View {
//    let video: VideoItem
//    @State private var isReady: Bool = false
//    @State private var isActive: Bool = true
//    @State private var viewID = UUID()
//    
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            // Video Card Base
//            ZStack(alignment: .bottomLeading) {
//                Color.white.opacity(0.05)
//                
//                VideoPlayerView(url: video.url, isReady: $isReady, isActive: $isActive)
//                    .id(viewID)
//                    .opacity(isReady ? 1 : 0)
//                    .scaleEffect(isReady ? 1 : 0.98)
//                    .frame(height: 250)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                
//                // Loading indicator
//                if !isReady {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .scaleEffect(1.5)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
//                
//                // Title overlay
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(video.title)
//                        .font(Utilities.font(.Bold, size: 12))
//                        .foregroundColor(.white)
//                        .lineLimit(2)
//                }
//                .padding(12)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background {
//                    LinearGradient(
//                        colors: [.clear, .black.opacity(0.8)],
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//            }
//            .frame(height: 250)
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .overlay {
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(.white.opacity(0.1), lineWidth: 1)
//            }
//            
//            // Like badge
////            Image(systemName: "heart.fill")
////                .font(.system(size: 14))
////                .foregroundColor(.pink)
////                .padding(8)
////                .background(
////                    Circle()
////                        .fill(.black.opacity(0.5))
////                        .blur(radius: 10)
////                )
////                .background(
////                    Circle()
////                        .fill(.white.opacity(0.2))
////                )
////                .padding(10)
//        }
//        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
//        .animation(.easeOut(duration: 0.4), value: isReady)
//        .onAppear {
//            viewID = UUID()
//            isReady = false
//        }
//    }
//}

// MARK: - Color Extension for Hex
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}

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
