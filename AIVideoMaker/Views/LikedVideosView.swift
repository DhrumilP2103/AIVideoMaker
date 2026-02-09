//
//  LikedVideosView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

struct LikedVideosView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedVideo: HomeResponseVideos?
    @State private var selectedVideoIndex: Int = 0
    @State private var isNavForDetail: Bool = false
    @Namespace private var videoTransition
    
    // Sample liked videos data - Replace with actual data from API/database
    @State private var likedVideos: [HomeResponseVideos] = [
        HomeResponseVideos(
            id: 1,
            categoryId: 1,
            title: "Morning Motivation",
            thumbnail: "https://picsum.photos/400/600?random=1",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            duration: "0:45",
            likes: 1250
        ),
        HomeResponseVideos(
            id: 2,
            categoryId: 2,
            title: "Workout Energy",
            thumbnail: "https://picsum.photos/400/600?random=2",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            duration: "1:20",
            likes: 890
        ),
        HomeResponseVideos(
            id: 3,
            categoryId: 1,
            title: "Nature Vibes",
            thumbnail: "https://picsum.photos/400/600?random=3",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            duration: "0:55",
            likes: 2100
        ),
        HomeResponseVideos(
            id: 4,
            categoryId: 3,
            title: "Music Flow",
            thumbnail: "https://picsum.photos/400/600?random=4",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
            duration: "1:10",
            likes: 1580
        ),
        HomeResponseVideos(
            id: 5,
            categoryId: 2,
            title: "Fitness Goals",
            thumbnail: "https://picsum.photos/400/600?random=5",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
            duration: "0:38",
            likes: 945
        ),
        HomeResponseVideos(
            id: 6,
            categoryId: 1,
            title: "Daily Inspiration",
            thumbnail: "https://picsum.photos/400/600?random=6",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
            duration: "1:05",
            likes: 1720
        )
    ]
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            // Background
            Color._041_C_32.ignoresSafeArea()
            
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
                    Text("\(likedVideos.count) video\(likedVideos.count != 1 ? "s" : "")")
                        .font(Utilities.font(.Medium, size: 14))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Video Grid
                if likedVideos.isEmpty {
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
                            ForEach(Array(likedVideos.enumerated()), id: \.element.id) { index, video in
                                VideoCard(video: video, isActive: .constant(true))
                                    .onTapGesture {
                                        impactFeedback.impactOccurred()
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            selectedVideo = video
                                            selectedVideoIndex = index
                                            isNavForDetail = true
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
        .navigationDestination(isPresented: $isNavForDetail) {
            if selectedVideo != nil {
                VideoReelsView(
                    videos: likedVideos,
                    startIndex: selectedVideoIndex,
                    animation: videoTransition,
                    isNavForDetail: $isNavForDetail
                )
                .toolbar(.hidden)
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
    NavigationStack {
        LikedVideosView()
    }
}
