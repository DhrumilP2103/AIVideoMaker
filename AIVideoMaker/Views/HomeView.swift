import SwiftUI
import AVFoundation

struct HomeView: View {
    @State private var selectedCategory: VideoCategory = .trending
    @State private var selectedVideo: VideoItem?
    @State private var isNavForDetail: Bool = false
    @Namespace private var categoryAnimation
    @Namespace private var videoTransition
    
    // Sample Video Data
    let videos: [VideoItem] = VideoItem.sampleData
    
    var body: some View {
        VStack(spacing: 0) {
            // Premium Top Category Tab Bar
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(VideoCategory.allCases, id: \.self) { category in
                            CategoryItem(category: category)
                                .id(category)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                .onChange(of: selectedCategory) { old, newValue in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            
            // Content Area with 2-Column Video Grid
            TabView(selection: $selectedCategory) {
                ForEach(VideoCategory.allCases, id: \.self) { category in
                    ScrollView {
                        let filteredVideos = videos.filter { $0.category == category }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 15) {
                            ForEach(filteredVideos) { video in
                                VideoCard(video: video)
                                    .matchedGeometryEffect(id: video.id.uuidString, in: videoTransition)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            selectedVideo = video
                                            isNavForDetail = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .padding(.bottom, 100) // Space for bottom tab bar
                    }
                    .tag(category)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationDestination(isPresented: $isNavForDetail) {
            if let video = selectedVideo {
                VideoDetailView(video: video, animation: videoTransition, isNavForDetail: $isNavForDetail)
                    .navigationBarHidden(true)
            }
        }
    }
    
    @ViewBuilder
    func CategoryItem(category: VideoCategory) -> some View {
        let isSelected = selectedCategory == category
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? category.icon + ".fill" : category.icon)
                    .font(.system(size: 14))
                
                Text(category.rawValue)
                    .font(Utilities.font(isSelected ? .Bold : .Medium, size: 15))
            }
            .foregroundColor(isSelected ? .black : .white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                if isSelected {
                    Capsule()
                        .fill(.white)
                        .matchedGeometryEffect(id: "CATEGORY_CAPSULE", in: categoryAnimation)
                } else {
                    Capsule()
                        .fill(.white.opacity(0.05))
                        .overlay {
                            Capsule()
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        }
                }
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
    }
}

// MARK: - Video Card View
struct VideoCard: View {
    let video: VideoItem
    @State private var isReady: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.white.opacity(0.05)
            
            VideoPlayerView(url: video.url, isReady: $isReady)
                .opacity(isReady ? 1 : 0)
                .scaleEffect(isReady ? 1 : 0.98)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(Utilities.font(.Bold, size: 12))
                    .foregroundColor(.white)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .animation(.easeOut(duration: 0.4), value: isReady)
    }
}

// MARK: - Custom Video Player Wrapper
struct VideoPlayerView: UIViewRepresentable {
    let url: URL
    @Binding var isReady: Bool
    
    func makeUIView(context: Context) -> LoopingPlayerUIView {
        let view = LoopingPlayerUIView(url: url)
        view.onPlaybackStarted = {
            DispatchQueue.main.async {
                isReady = true
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {}
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    var onPlaybackStarted: (() -> Void)?

    init(url: URL) {
        super.init(frame: .zero)
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        
        // playerItem.forwardPlaybackEndTime = CMTime(seconds: 5, preferredTimescale: 600)
        
        let player = AVQueuePlayer(playerItem: playerItem)
        player.isMuted = true
        self.queuePlayer = player
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        // Notify when playback starts
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        
        player.play()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus" {
            if let player = object as? AVQueuePlayer, player.timeControlStatus == .playing {
                onPlaybackStarted?()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        queuePlayer?.removeObserver(self, forKeyPath: "timeControlStatus")
        queuePlayer?.pause()
        queuePlayer = nil
        playerLooper = nil
    }
}

// MARK: - Data Models
struct VideoItem: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
    let category: VideoCategory
    
    static var sampleData: [VideoItem] {
        // Reliable direct MP4 URLs from Google's sample video bucket
        let trendingUrl = URL(string: "https://www.pexels.com/download/video/7515918/")!
        let horrorUrl = URL(string: "https://www.pexels.com/download/video/5427399/")!
        let funnyUrl = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!
        let cartoonUrl = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
        let babyUrl = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!
        
        let extraTrending = URL(string: "https://www.pexels.com/download/video/27670450/")!
        let extraTrending2 = URL(string: "https://www.pexels.com/download/video/7866852/")!
        let extraHorror = URL(string: "https://www.pexels.com/download/video/5435725/")!
        let extraHorror2 = URL(string: "https://www.pexels.com/download/video/34564177/")!
        let extraHorror3 = URL(string: "https://www.pexels.com/download/video/5435720/")!
        let extraFunny = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!
        
        return [
            VideoItem(title: "Trending Clip 1", url: trendingUrl, category: .trending),
            VideoItem(title: "Trending Clip 2", url: extraTrending, category: .trending),
            VideoItem(title: "Trending Clip 3", url: extraTrending2, category: .trending),
            VideoItem(title: "Horror Clip 1", url: horrorUrl, category: .horror),
            VideoItem(title: "Horror Clip 2", url: extraHorror, category: .horror),
            VideoItem(title: "Horror Clip 2", url: extraHorror2, category: .horror),
            VideoItem(title: "Horror Clip 2", url: extraHorror3, category: .horror),
            VideoItem(title: "Funny Clip 1", url: funnyUrl, category: .funny),
            VideoItem(title: "Funny Clip 2", url: extraFunny, category: .funny),
            VideoItem(title: "Cartoon Clip 1", url: cartoonUrl, category: .cartoon),
            VideoItem(title: "Cartoon Clip 2", url: trendingUrl, category: .cartoon),
            VideoItem(title: "Baby Clip 1", url: babyUrl, category: .babyVideo),
            VideoItem(title: "Baby Clip 2", url: extraTrending, category: .babyVideo)
        ]
    }
}

enum VideoCategory: String, CaseIterable {
    case trending = "Trending"
    case horror = "Horror"
    case funny = "Funny"
    case cartoon = "Cartoon"
    case babyVideo = "Baby Video"
    
    var icon: String {
        switch self {
        case .trending: return "flame"
        case .horror: return "ghost"
        case .funny: return "face.smiling"
        case .cartoon: return "paintbrush.pointed"
        case .babyVideo: return "figure.baby"
        }
    }
}

#Preview {
    DashBoardView()
}

