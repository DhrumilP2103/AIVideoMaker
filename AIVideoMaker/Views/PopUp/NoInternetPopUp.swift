//
//  NoInternetPopUp.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 11/02/26.
//


import SwiftUI

/// Use for NoInternet or UnderMaintenance
struct NoInternetPopUp: View {
    @EnvironmentObject var appState: NetworkAppState
    var retryAction: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 12) {
                        Text("No internet connection!")
                            .font(Utilities.font(.Bold, size: 18))
                            .foregroundColor(.white)
                        
//                        Image(.icNoInternet)
//                            .resizable()
//                            .frame(width: 18, height: 18)
                        Spacer()
                    }
                    .padding(.horizontal,24)
                    .padding(.top, 36)
                    .padding(.bottom, 6)
                    
                    HStack {
                        Text("Oops! It looks like you're offline. Please check your internet connection and try again.")
                            .font(Utilities.font(.Regular, size: 16))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                       
                    Spacer()
                    Button {
                        if checkInternet() {
                            retryAction()
                            appState.isNoInternet = false
                            appState.retryRequestedForAPI = nil
                        }
                    } label: {
                        ZStack {
                            Text("Retry")
                                .font(Utilities.font(.Regular, size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity,maxHeight: .infinity)
                        }
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.1))
                        )
                        .mask { RoundedRectangle(cornerRadius: 12) }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 46)
                    .buttonStyle(NoTapAnimationStyle())
                }
                .frame(maxWidth: .infinity).frame(height: 300)
                .background(
                    LinearGradient(
                        colors: [
                            Color._041_C_32,
                            Color(hex: "064663")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .mask { RoundedRectangle(cornerRadius: 24) }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundClearView())
    }
    
}

#Preview {
    NoInternetPopUp() { }
}

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Make the whole button surface tappable. Without this only content in the label is tappable and not whitespace. Order is important so add it before the tap gesture
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}
