//
//  ImageSourcePickerPopup.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 09/02/26.
//

import SwiftUI


struct ImageSourcePickerPopup: View {
    @Binding var isPresented: Bool
    let onCameraSelected: () -> Void
    let onGallerySelected: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Dimmed Background
            Color.black.opacity(showContent ? 0.6 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissPopup()
                }
            
            // Popup Content
            VStack(spacing: 20) {
                // Title
                Text("Choose Photo Source")
                    .font(Utilities.font(.Bold, size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                // Options
                VStack(spacing: 14) {
                    // Camera Option
                    PickerOptionButton(
                        icon: "camera.fill",
                        title: "Camera",
                        iconColor: Color(hex: "667eea")
                    ) {
                        dismissPopup()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onCameraSelected()
                        }
                    }
                    
                    // Gallery Option
                    PickerOptionButton(
                        icon: "photo.on.rectangle.angled",
                        title: "Photo Library",
                        iconColor: Color(hex: "764ba2")
                    ) {
                        dismissPopup()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onGallerySelected()
                        }
                    }
                }
                
                // Cancel Button
                Button {
                    dismissPopup()
                } label: {
                    Text("Cancel")
                        .font(Utilities.font(.SemiBold, size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(.white.opacity(0.15), lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(PickerButtonStyle())
                .padding(.top, 4)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color._041_C_32.opacity(0.95),
                                Color._041_C_32.opacity(0.98)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 15)
            .padding(.horizontal, 40)
            .scaleEffect(showContent ? 1.0 : 0.8)
            .opacity(showContent ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    private func dismissPopup() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// MARK: - Picker Option Button
struct PickerOptionButton: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                // Icon Container
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    iconColor.opacity(0.25),
                                    iconColor.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                // Title
                Text(title)
                    .font(Utilities.font(.SemiBold, size: 17))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Chevron
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.06)
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
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PickerButtonStyle())
    }
}
