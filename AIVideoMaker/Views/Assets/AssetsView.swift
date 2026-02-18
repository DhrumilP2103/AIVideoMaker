//
//  AssetsView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

struct AssetsView: View {
    @StateObject var viewModel = AssetsViewModel()
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: NetworkAppState
    
    @State private var selectedVideo: ResponseVideos?
    @Namespace private var videoTransition
    
    // Group videos by date
    var groupedVideos: [(String, [ResponseVideos])] {
        let grouped = Dictionary(grouping: viewModel.assetsResponseData) { video in
            getDateString(from: video.createdAt)
        }
        return grouped.sorted { (first, second) in
            // Sort by date descending
            let date1 = getDate(from: first.value.first?.createdAt)
            let date2 = getDate(from: second.value.first?.createdAt)
            return date1 > date2
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.assetsResponseData.isEmpty {
                EmptyStateView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        ForEach(groupedVideos, id: \.0) { dateGroup in
                            DateSection(
                                dateTitle: dateGroup.0,
                                videos: dateGroup.1,
                                onVideoTap: { video in
                                    selectedVideo = video
                                    
                                    self.router.push(
                                        AssetVideoDetailView(
                                            video: video,
                                            templateName: video.categoryName ?? "Unknown Template",
                                            animation: videoTransition
                                        ),
                                        route: .assetVideoDetailView
                                    )
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear() {
            self.viewModel.assetsList(appState: self.appState)
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
    
    // MARK: - Helper Functions
    
    private func getDate(from dateString: String?) -> Date {
        guard let dateString = dateString else { return Date() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    private func getDateString(from dateString: String?) -> String {
        let date = getDate(from: dateString)
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Date Section
struct DateSection: View {
    let dateTitle: String
    let videos: [ResponseVideos]
    let onVideoTap: (ResponseVideos) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Date Header
            HStack {
                Text(dateTitle)
                    .font(Utilities.font(.Bold, size: 20))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(videos.count) video\(videos.count > 1 ? "s" : "")")
                    .font(Utilities.font(.Medium, size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 4)
            
            // Video Grid
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ],
                spacing: 15
            ) {
                ForEach(videos.indices, id: \.self) { index in
                    let video = videos[index]
                    AssetVideoCard(video: video)
                        .onTapGesture {
                            onVideoTap(video)
                        }
                }
            }
        }
    }
}

// MARK: - Asset Video Card
struct AssetVideoCard: View {
    let video: ResponseVideos
    @State private var isReady: Bool = false
    @State private var isActive: Bool = true
    @State private var viewID = UUID()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.white.opacity(0.05)
            
            // Video Preview
            if let videoUrlString = video.videoUrl, let videoURL = URL(string: videoUrlString) {
                VideoPlayerView(url: videoURL, isReady: $isReady, isActive: $isActive)
                    .id(viewID)
                    .opacity(isReady ? 1 : 0)
                    .scaleEffect(isReady ? 1 : 0.98)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    }
            }
            
            // Loading indicator
            if !isReady {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Video Info Overlay
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Spacer()
                    
                    // Duration Badge
                    if let duration = video.duration {
                        Text(duration)
                            .font(Utilities.font(.Bold, size: 11))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background {
                                Capsule()
                                    .fill(.black.opacity(0.7))
                            }
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 8)
                
                Spacer()
                
                // Title and Template
                VStack(alignment: .leading, spacing: 2) {
                    Text(video.title ?? "Untitled")
                        .font(Utilities.font(.Bold, size: 13))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "film.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(video.categoryName ?? "Unknown Template")
                            .font(Utilities.font(.Medium, size: 10))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .animation(.easeOut(duration: 0.4), value: isReady)
        .onAppear {
            viewID = UUID()
            isReady = false
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 120, height: 120)
                
                Image(systemName: "video.badge.plus")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.3))
            }
            
            VStack(spacing: 8) {
                Text("No Videos Yet")
                    .font(Utilities.font(.Bold, size: 22))
                    .foregroundColor(.white)
                
                Text("Create your first video from templates")
                    .font(Utilities.font(.Medium, size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Asset Video Detail View
struct AssetVideoDetailView: View {
    let video: ResponseVideos
    let templateName: String
    let animation: Namespace.ID
    
    @State private var isCurrentVideo: Bool = true
    
    var body: some View {
        ZStack {
            // Reuse existing VideoDetailView but with custom back button behavior
            VideoDetailView(
                video: video,
                animation: animation,
                isCurrentVideo: $isCurrentVideo
            )
        }.ignoresSafeArea()
    }
}

#Preview {
    DashBoardView()
}
