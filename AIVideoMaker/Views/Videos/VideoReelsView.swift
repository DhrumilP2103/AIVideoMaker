import SwiftUI

struct VideoReelsView: View {
    let videos: [ResponseVideos]
    let startIndex: Int
    let animation: Namespace.ID
    
    @State private var currentIndex: Int? = nil
    @EnvironmentObject var appState: NetworkAppState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
//                ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                ForEach(videos.indices, id: \.self) { index in
                    let video = videos[index]
                    VideoDetailView(
                        video: video,
                        animation: animation,
                        isCurrentVideo: .constant(currentIndex == index)
                    ).environmentObject(appState)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .containerRelativeFrame(.vertical)
                    .id(index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Color._041_C_32)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentIndex)
        .ignoresSafeArea()
        .onAppear {
            currentIndex = startIndex
        }
    }
}
