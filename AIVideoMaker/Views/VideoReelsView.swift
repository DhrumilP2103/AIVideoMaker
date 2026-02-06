import SwiftUI

struct VideoReelsView: View {
    let videos: [HomeResponseVideos]
    let startIndex: Int
    let animation: Namespace.ID
    @Binding var isNavForDetail: Bool
    
    @State private var currentIndex: Int? = nil
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                    VideoDetailView(
                        video: video,
                        animation: animation,
                        isNavForDetail: $isNavForDetail,
                        isCurrentVideo: .constant(currentIndex == index)
                    )
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
