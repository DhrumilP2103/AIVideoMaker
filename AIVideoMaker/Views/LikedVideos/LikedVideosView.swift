//
//  LikedVideosView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

struct LikedVideosView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router
    @StateObject var viewModel = LikedVideosViewModel()
    @EnvironmentObject var appState: NetworkAppState
    
    @State private var selectedVideo: ResponseVideos?
    @State private var selectedVideoIndex: Int = 0
    @Namespace private var videoTransition
    
    // Sample liked videos data - Replace with actual data from API/database
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color._041_C_32,
                    Color(hex: "064663")
                ],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    // Back Button
                    Button {
                        impactFeedback.impactOccurred()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Title
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.pink)
                        
                        Text("Liked Videos")
                            .font(Utilities.font(.Bold, size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Videos Count
                HStack {
                    Text("\(viewModel.likedVideosData.count) video\(viewModel.likedVideosData.count != 1 ? "s" : "")")
                        .font(Utilities.font(.Medium, size: 14))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Video Grid
                if viewModel.likedVideosData.isEmpty {
                    EmptyLikedVideosView()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 15),
                                GridItem(.flexible(), spacing: 15)
                            ],
                            spacing: 15
                        ) {
//                            ForEach(Array(viewModel.likedVideosData.enumerated()), id: \.element.id) {
                            ForEach(viewModel.likedVideosData.indices, id: \.self) { index  in
                                let video = viewModel.likedVideosData[index]
                                VideoCard(video: video, isActive: .constant(true))
                                    .onTapGesture {
                                        impactFeedback.impactOccurred()
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            selectedVideo = video
                                            selectedVideoIndex = index
                                            
                                            self.router.push(
                                                VideoReelsView(
                                                    videos: viewModel.likedVideosData,
                                                    startIndex: selectedVideoIndex,
                                                    animation: videoTransition
                                                ).environmentObject(appState),
                                                route: .videoReelsView
                                            )
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear() {
            self.viewModel.likedVideosList(appState: self.appState)
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

// MARK: - Empty State View
struct EmptyLikedVideosView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(.white.opacity(0.05))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.pink.opacity(0.5))
            }
            
            VStack(spacing: 8) {
                Text("No Liked Videos Yet")
                    .font(Utilities.font(.Bold, size: 22))
                    .foregroundColor(.white)
                
                Text("Start liking videos to see them here")
                    .font(Utilities.font(.Medium, size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LikedVideosView()
}
