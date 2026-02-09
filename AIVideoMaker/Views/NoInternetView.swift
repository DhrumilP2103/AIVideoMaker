//
//  NoInternetView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

struct NoInternetView: View {
    var onRetry: () -> Void
    @State private var isAnimating = false
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    // Prevent dismissal by tapping outside for now
                }
            
            // Popup Card
            VStack(spacing: 24) {
                // WiFi Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(isAnimating ? 5 : -5))
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.top, 8)
                
                // Content
                VStack(spacing: 12) {
                    Text("No Internet Connection")
                        .font(Utilities.font(.Bold, size: 22))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Please check your internet connection and try again")
                        .font(Utilities.font(.Medium, size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                
                // Retry Button
                Button {
                    impactFeedback.impactOccurred()
                    onRetry()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Retry")
                            .font(Utilities.font(.SemiBold, size: 16))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.blue)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
            .frame(width: 320)
            .padding(.vertical, 32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "0F2A3A"))
                    .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 15)
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Color Extension (if not already present)
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
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        NoInternetView {
            print("Retry tapped")
        }
    }
}
