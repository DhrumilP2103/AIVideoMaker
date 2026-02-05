import SwiftUI
import AVFoundation
import AVKit

struct VideoDetailView: View {
    let video: VideoItem
    let animation: Namespace.ID
    @Binding var isNavForDetail: Bool
    
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = true
    @State private var progress: Double = 0
    @State private var duration: Double = 0
    @State private var isDragging: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Full Screen Video
            Group {
                if let player = player {
                    ZStack {
                        CustomAVPlayerView(player: player)
                            .ignoresSafeArea()
                    }
                    .matchedGeometryEffect(id: video.id.uuidString, in: animation)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isPlaying.toggle()
                            isPlaying ? player.play() : player.pause()
                        }
                    }
                }
            }
            
            // Play/Pause Center Indicator
            if !isPlaying {
                Image(systemName: "play.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.8))
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Back Button
            VStack {
                HStack {
                    Button {
                        isNavForDetail = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                Spacer()
            }
            
            // Right Side Actions
            HStack {
                Spacer()
                VStack(spacing: 25) {
                    Spacer()
                    
                    SideActionButton(icon: "heart.fill", label: "1.2k", color: .red)
                    SideActionButton(icon: "arrowshape.turn.up.right.fill", label: "Share")
                    SideActionButton(icon: "ellipsis", label: "More")
                    
                    Spacer()
                        .frame(height: 150)
                }
                .padding(.trailing, 20)
            }
            
            // Bottom Controls and Button
            VStack(spacing: 20) {
                Spacer()
                
                // Progress Bar
                VStack(spacing: 8) {
                    CustomSlider(value: $progress, range: 0...1, isDragging: $isDragging) { newValue in
                        seek(to: newValue)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Make Video Button
                Button {
                    // Make Video Action
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "video.badge.plus.fill")
                        Text("Make Video")
                        .font(Utilities.font(.Bold, size: 16))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: .white.opacity(0.3), radius: 15, x: 0, y: 8)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    private func setupPlayer() {
        let player = AVPlayer(url: video.url)
        self.player = player
        
        // Loop video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        // Track progress
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
            guard !isDragging else { return }
            if let duration = player.currentItem?.duration.seconds, duration > 0 {
                self.duration = duration
                self.progress = time.seconds / duration
            }
        }
        
        player.play()
    }
    
    private func seek(to value: Double) {
        guard let player = player else { return }
        let targetTime = CMTime(seconds: value * duration, preferredTimescale: 600)
        player.seek(to: targetTime)
    }
}

// MARK: - Side Action Button
struct SideActionButton: View {
    let icon: String
    let label: String
    var color: Color = .white
    
    var body: some View {
        Button {
            // Action
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .padding(12)
                    .background(.white.opacity(0.1))
                    .clipShape(Circle())
                
                Text(label)
                    .font(Utilities.font(.Bold, size: 11))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Custom Slider (Progress Bar)
struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    @Binding var isDragging: Bool
    let onEditingChanged: (Double) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(.white)
                    .frame(width: geometry.size.width * CGFloat(value), height: 4)
                
                Circle()
                    .fill(.white)
                    .frame(width: 12, height: 12)
                    .offset(x: geometry.size.width * CGFloat(value) - 6)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                isDragging = true
                                let newValue = min(max(0, Double(gesture.location.x / geometry.size.width)), 1)
                                value = newValue
                            }
                            .onEnded { _ in
                                isDragging = false
                                onEditingChanged(value)
                            }
                    )
            }
        }
        .frame(height: 12)
    }
}

// MARK: - Simple AVPlayer View
struct CustomAVPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

