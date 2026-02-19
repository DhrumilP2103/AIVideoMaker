//
//  PrivacyPolicyView.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 17/02/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: NetworkAppState
    @StateObject var viewModel = PrivacyPolicyViewModel()
    
    @State var isPrivacy: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color._041_C_32,
                        Color(hex: "064663")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            VStack(spacing: 0) {
                // Header
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
                    
                    Text(self.isPrivacy ? "Privacy Policy" : "Terms & Conditions")
                        .font(Utilities.font(.Bold, size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
//                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // HTML Content
                let text = self.isPrivacy ? self.viewModel.privacyPolicyData.policy : self.viewModel.privacyPolicyData.termConditions
                if let htmlContent = text, !htmlContent.isEmpty {
                    HTMLStringView(htmlContent: htmlContent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Loading or Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Loading privacy policy...")
                            .font(Utilities.font(.Medium, size: 16))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            viewModel.getPrivacyPolicy(appState: appState)
        }

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
    }
}

#Preview {
    PrivacyPolicyView()
}
