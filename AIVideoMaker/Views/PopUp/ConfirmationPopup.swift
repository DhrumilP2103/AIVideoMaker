//
//  ConfirmationPopup.swift
//  AIVideoMaker
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct ConfirmationPopup: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let icon: String
    let confirmActionTitle: String
    var isDestructive: Bool = false
    let confirmAction: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Dimmed Background
//            Color.black.opacity(showContent ? 0.6 : 0)
//                .ignoresSafeArea()
//                .onTapGesture {
//                    dismissPopup()
//                }
            
            // Popup Content
            VStack(spacing: 20) {
                // Icon (Optional - reusing Login/Assets style)
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(icon).resizable()
                        .frame(width: 26, height: 26)
                }
                
                // Text
                VStack(spacing: 8) {
                    Text(title)
                        .font(Utilities.font(.Bold, size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(Utilities.font(.Medium, size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 10)
                
                // Actions
                HStack(spacing: 12) {
                    // Cancel Button
                    Button {
                        dismissPopup()
                    } label: {
                        Text("Cancel")
                            .font(Utilities.font(.SemiBold, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.white.opacity(0.1))
                            )
                    }
                    
                    // Confirm Button
                    Button {
                        confirmAction()
                        dismissPopup()
                    } label: {
                        Text(confirmActionTitle)
                            .font(Utilities.font(.SemiBold, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(isDestructive ? Color.red : Color.blue)
                            )
                    }
                }
                .padding(.top, 10)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color._041_C_32,
                                Color(hex: "064663")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color.white.opacity(0.3),
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
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPresented = false
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ConfirmationPopup(
            isPresented: .constant(true),
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            icon: "ic_delete",
            confirmActionTitle: "Delete",
            isDestructive: true,
            confirmAction: {}
        )
    }
}
