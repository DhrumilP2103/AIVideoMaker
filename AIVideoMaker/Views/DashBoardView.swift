//
//  DashBoardView.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 04/02/26.
//

import SwiftUI

struct DashBoardView: View {
    @State private var activeTab: Tab = .home
    @Namespace private var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Premium Background
            ZStack {
                Color._041_C_32
                
                // Subtle Glows
                RadialGradient(colors: [Color.white.opacity(0.05), .clear], center: .topLeading, startRadius: 0, endRadius: 400)
                RadialGradient(colors: [Color.white.opacity(0.03), .clear], center: .bottomTrailing, startRadius: 0, endRadius: 500)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header Section
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        // Premium Background
                        ZStack {
                            Color._041_C_32
                            
                            // Subtle Glows
                            RadialGradient(colors: [Color.white.opacity(0.05), .clear], center: .topLeading, startRadius: 0, endRadius: 400)
                            RadialGradient(colors: [Color.white.opacity(0.03), .clear], center: .bottomTrailing, startRadius: 0, endRadius: 500)
                        }
                        .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            // Top Header Section
                            HeaderView()
                            
                            // Content Area (Swipe Disabled for Main Tabs)
                            Group {
                                switch activeTab {
                                case .home:
                                    HomeView()
                                case .assets:
                                    Text("Assets View")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                case .profile:
                                    Text("Profile View")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        // Premium Custom Tab Bar
                        CustomBottomBar()
                            .padding(.bottom, 20)
                    }
                }
            }
            
            
            
        }
    }
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            // Logo and Name
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.1))
                        .frame(width: 44, height: 44)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        }
                    
                    Image(systemName: "sparkles.tv")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Video Maker")
                        .font(Utilities.font(.Bold, size: 18))
                        .foregroundColor(.white)
                    Text("Funny Edition")
                        .font(Utilities.font(.Medium, size: 10))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
            
            // Subscription Button
            Button {
                // Subscription Action
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.caption)
                    
                    Text("PRO")
                        .font(Utilities.font(.Bold, size: 12))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    Capsule()
                        .fill(LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "FFA500")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: Color(hex: "FFA500").opacity(0.4), radius: 12, x: 0, y: 6)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background {
            // Subtle glass effect for the header
            Rectangle()
                .fill(.clear)
                .background(BlurView(style: .systemUltraThinMaterialDark).opacity(0.8))
                .mask {
                    LinearGradient(colors: [.black, .black, .clear], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CustomBottomBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                let isActive = activeTab == tab
                
                HStack(spacing: 10) {
                    Image(isActive ? tab.iconFill : tab.icon).resizable().renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(isActive ? .black : .white)
                    
                    if isActive {
                        Text(tab.rawValue)
                            .font(Utilities.font(.SemiBold, size: 14))
                            .matchedGeometryEffect(id: "TEXT", in: animation)
                    }
                }
                .foregroundStyle(isActive ? .black : .white.opacity(0.6))
                .padding(.vertical, 12)
                .padding(.horizontal, isActive ? 22 : 16)
                .background {
                    if isActive {
                        Capsule()
                            .fill(.white)
                            .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .contentShape(Rectangle())
                .scaleEffect(isActive ? 1.02 : 1.0)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        activeTab = tab
                    }
                }
                
                if tab != Tab.allCases.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .fill(.white.opacity(0.1))
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
                .background(BlurView(style: .systemUltraThinMaterialDark).clipShape(Capsule()))
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .padding(.horizontal, 30)
    }
}
// Helper for Blur Effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

enum Tab: String, CaseIterable {
    case home = "Home"
    case assets = "Assets"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home: return "ic_home"
        case .assets: return "ic_folder"
        case .profile: return "ic_user"
        }
    }
    
    var iconFill: String {
        switch self {
        case .home: return "ic_home_fill"
        case .assets: return "ic_folder_fill"
        case .profile: return "ic_user_fill"
        }
    }
}

#Preview {
    DashBoardView()
}

// Extension for Hex Colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


