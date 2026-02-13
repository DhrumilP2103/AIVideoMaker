//
//  LoginSheet.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI
import GoogleSignIn

struct LoginSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @StateObject var signInManager = GoogleSignInManager.shared
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            // Premium Background
            ZStack {
                LinearGradient(
                    colors: [
                        Color._041_C_32,
                        Color(hex: "064663")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
                // Logo/Icon Section
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(color: Color(hex: "FFA500").opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        Image(systemName: "sparkles.tv")
                            .font(.system(size: 38))
                            .foregroundColor(.black)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Welcome to Rimoo")
                            .font(Utilities.font(.Bold, size: 24))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Sign in to create amazing videos")
                            .font(Utilities.font(.Medium, size: 15))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                
                Spacer().frame(height: 30)
                
                // Login Buttons
                VStack(spacing: 16) {
                    // Google Login Button
                    Button {
                        impactFeedback.impactOccurred()
                        handleGoogleLogin()
                    } label: {
                        HStack(spacing: 12) {
                            Image("ic_google").resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("Continue with Google")
                                .font(Utilities.font(.SemiBold, size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                    }
                    .disabled(isLoading)
                    .opacity(isLoading ? 0.6 : 1.0)
                    
                    // Apple Login Button
                    Button {
                        impactFeedback.impactOccurred()
                        handleAppleLogin()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "apple.logo")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            Text("Continue with Apple")
                                .font(Utilities.font(.SemiBold, size: 16))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.black)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                }
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                    }
                    .disabled(isLoading)
                    .opacity(isLoading ? 0.6 : 1.0)
                }
                .padding(.horizontal, 30)
                
                Spacer().frame(height: 20)
                
                // Loading Indicator
//                if isLoading {
//                    HStack(spacing: 8) {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        
//                        Text("Signing in...")
//                            .font(Utilities.font(.Medium, size: 14))
//                            .foregroundColor(.white.opacity(0.7))
//                    }
//                    .padding(.vertical, 10)
//                } else {
//                    Spacer().frame(height: 38)
//                }
                
                // Terms & Privacy
                VStack(spacing: 8) {
                    Text("By continuing, you agree to our")
                        .font(Utilities.font(.Medium, size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    
                    HStack(spacing: 4) {
                        Button {
                            // TODO: Open Terms
                        } label: {
                            Text("Terms of Service")
                                .font(Utilities.font(.SemiBold, size: 12))
                                .foregroundColor(.white.opacity(0.7))
                                .underline()
                        }
                        
                        Text("and")
                            .font(Utilities.font(.Medium, size: 12))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Button {
                            // TODO: Open Privacy Policy
                        } label: {
                            Text("Privacy Policy")
                                .font(Utilities.font(.SemiBold, size: 12))
                                .foregroundColor(.white.opacity(0.7))
                                .underline()
                        }
                    }
                }
                
//                Spacer()
            }
        }
    }
    
    // MARK: - Login Actions
    private func handleGoogleLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else {
            return
        }
        
        signInManager.signIn(presenting: root) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("idToken:", user.idToken?.tokenString ?? "")
                    print("userID:", user.userID ?? "")
                    
                case .failure(let error):
                    // Google sign-in failed. Implement handling as needed.
                    dump("error: \(error)")
                    break
                }
            }
        }
    }
    
    private func handleAppleLogin() {
        isLoading = true
        
        // TODO: Implement Apple Sign-In
        // For now, just simulate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            dismiss()
        }
    }
}

// MARK: - RoundedCorner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LoginSheet()
        .presentationDetents([.medium])
}
