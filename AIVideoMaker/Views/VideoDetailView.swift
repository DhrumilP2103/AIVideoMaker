import SwiftUI
import AVFoundation
import AVKit

struct VideoDetailView: View {
    let video: HomeResponseVideos
    let animation: Namespace.ID
    @Binding var isNavForDetail: Bool
    @Binding var isCurrentVideo: Bool
    
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = true
    @State private var isLoading: Bool = true
    @State private var progress: Double = 0
    @State private var duration: Double = 0
    @State private var isDragging: Bool = false
    @State private var showUI: Bool = false
    @State private var showCreateVideo: Bool = false
    @State private var showLoginSheet: Bool = false
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
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
                    .matchedGeometryEffect(id: video.id, in: animation)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isPlaying.toggle()
                            isPlaying ? player.play() : player.pause()
                        }
                    }
                }
            }
            
            // Loading Indicator
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .transition(.opacity.combined(with: .scale))
            }
            
            // Play/Pause Center Indicator
            if !isPlaying && !isLoading {
                Image(systemName: "play.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.8))
                    .scaleEffect(showUI ? 1.0 : 0.8)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: !isPlaying)
            }
            
            // Back Button
            VStack {
                HStack {
                    Button {
                        impactFeedback.impactOccurred()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isNavForDetail = false
                        }
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
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.leading, 24)
                    .padding(.top, 48)
                    .opacity(showUI ? 1 : 0)
                    .offset(y: showUI ? 0 : -20)
                    
                    Spacer()
                }
                Spacer()
            }
            
            // Right Side Actions
            HStack(alignment: .bottom) {
                // Left Side - Video Title
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    Text(video.title ?? "")
                        .font(Utilities.font(.Bold, size: 20))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
                        .background(
                            // Text stroke for better visibility
                            Text(video.title ?? "")
                                .font(Utilities.font(.Bold, size: 20))
                                .foregroundColor(.black.opacity(0.5))
                                .blur(radius: 1)
                        )
                        .padding(.bottom, 180)
                        .opacity(showUI ? 1 : 0)
                        .offset(x: showUI ? 0 : -20)
                }
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Right Side Actions
                VStack(spacing: 25) {
                    Spacer()
                    
                    SideActionButton(icon: "ic_heart_fill", label: "1.2k", color: .red)
                    SideActionButton(icon: "ic_share", label: "Share")
                    SideActionButton(icon: "ic_download", label: "Download")
                    
                    Spacer()
                        .frame(height: 150)
                }
                .padding(.trailing, 20)
                .opacity(showUI ? 1 : 0)
                .offset(x: showUI ? 0 : 20)
            }
            
            // Bottom Controls and Button
            VStack(spacing: 20) {
                Spacer()
                
                // Progress Bar with Time Display
                VStack(spacing: 8) {
                    // Progress Bar
                    CustomSlider(value: $progress, range: 0...1, isDragging: $isDragging) { newValue in
                        impactFeedback.impactOccurred()
                        seek(to: newValue)
                    }
                    .padding(.horizontal, 20)
                    .animation(.easeOut(duration: 0.1), value: progress)
                    
                    // Time Display
                    HStack {
                        Text(formatTime(progress * duration))
                            .font(Utilities.font(.Medium, size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text(formatTime(duration))
                            .font(Utilities.font(.Medium, size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 20)
                    
                    // Template Name
//                    HStack {
//                        Image(systemName: "film.fill")
//                            .font(.system(size: 10))
//                            .foregroundColor(.white.opacity(0.6))
//                        
//                        Text(video.template)
//                            .font(Utilities.font(.Medium, size: 13))
//                            .foregroundColor(.white.opacity(0.9))
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 4)
                }
                
                // Make Video Button
                Button {
                    impactFeedback.impactOccurred()
//                    showLoginSheet = true
                    showCreateVideo = true
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
                .buttonStyle(ScaleButtonStyle())
                .padding([.horizontal, .bottom], 30)
                .opacity(showUI ? 1 : 0)
                .offset(y: showUI ? 0 : 20)
            }
        }
        .blur(radius: self.showLoginSheet ? 2 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showUI)
        .onAppear {
            setupPlayer()
            // Animate UI elements in smoothly
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showUI = true
            }
        }
        .onChange(of: isCurrentVideo) { oldValue, newValue in
            if newValue {
                player?.play()
                isPlaying = true
            } else {
                player?.pause()
                isPlaying = false
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
        .navigationDestination(isPresented: $showCreateVideo) {
            CreateVideoView(video: video)
                .toolbar(.hidden)
        }
        .sheet(isPresented: $showLoginSheet) {
            LoginSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
    
    private func setupPlayer() {
        isLoading = true
        
        // Parse video URL from string
        guard let videoUrlString = video.videoUrl,
              let videoURL = URL(string: videoUrlString) else {
            print("Invalid video URL")
            isLoading = false
            return
        }
        
        // Use cached video if available
        let urlToPlay = VideoCacheManager.shared.getURLToPlay(for: videoURL)
        let player = AVPlayer(url: urlToPlay)
        self.player = player
        
        // Loop video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        // Track progress and detect when ready to play
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak player] time in
            guard !isDragging else { return }
            
            // Hide loading indicator when player starts playing
            if player?.timeControlStatus == .playing {
                isLoading = false
            }
            
            if let duration = player?.currentItem?.duration.seconds, duration > 0 {
                self.duration = duration
                self.progress = time.seconds / duration
            }
        }
        
        player.play()
    }
    
    private func seek(to value: Double) {
        guard let player = player, duration > 0 else { return }
        let targetTime = CMTime(seconds: value * duration, preferredTimescale: 600)
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "0:00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Side Action Button
struct SideActionButton: View {
    let icon: String
    let label: String
    var color: Color = .white
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Button {
            impactFeedback.impactOccurred()
            // Action
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    Image(icon).resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                }.frame(width: 40, height: 40)
                    .background(.black.opacity(0.3))
                    .clipShape(Circle())
                
                Text(label)
                    .font(Utilities.font(.Bold, size: 11))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
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
                // Background track
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(height: 4)
                
                // Progress track
                Rectangle()
                    .fill(.white)
                    .frame(width: geometry.size.width * CGFloat(value), height: 4)
                
                // Draggable handle
                Circle()
                    .fill(.white)
                    .frame(width: 12, height: 12)
                    .offset(x: geometry.size.width * CGFloat(value) - 6)
            }
            .contentShape(Rectangle()) // Make entire area tappable
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        isDragging = true
                        let newValue = min(max(0, Double(gesture.location.x / geometry.size.width)), 1)
                        value = newValue
                        // Seek immediately during drag for better UX
                        onEditingChanged(newValue)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
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
        controller.videoGravity = .resizeAspect
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

