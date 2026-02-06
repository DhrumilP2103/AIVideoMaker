//
//  VideoManager.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 06/02/26.
//

import Foundation
import AVFoundation
import SwiftUI

// MARK: - Video Card View
struct VideoCard: View {
    let video: HomeResponseVideos
    @Binding var isActive: Bool
    @State private var isReady: Bool = false
    @State private var viewID = UUID()
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.white.opacity(0.05)
            
            // Parse video URL from string
            if let videoUrlString = video.videoUrl,
               let videoURL = URL(string: videoUrlString) {
                VideoPlayerView(url: videoURL, isReady: $isReady, isActive: $isActive)
                    .id(viewID) // Use stable ID for view lifecycle
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
            
            VStack(alignment: .leading, spacing: 4) {

                Text(video.title ?? "Untitled")
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
        .onAppear {
            // Force recreation when view reappears
            viewID = UUID()
            isReady = false
        }
    }
}

// MARK: - Custom Video Player Wrapper
struct VideoPlayerView: UIViewRepresentable {
    let url: URL
    @Binding var isReady: Bool
    @Binding var isActive: Bool
    
    func makeUIView(context: Context) -> LoopingPlayerUIView {
        let view = LoopingPlayerUIView(url: url)
        
        // Use coordinator to manage callback
        context.coordinator.isReadyBinding = _isReady
        view.onPlaybackStarted = {
            DispatchQueue.main.async {
                context.coordinator.isReadyBinding?.wrappedValue = true
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {
        // Update coordinator binding
        context.coordinator.isReadyBinding = _isReady
        
        if isActive {
            uiView.resumePlayback()
        } else {
            uiView.pausePlayback()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var isReadyBinding: Binding<Bool>?
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    var onPlaybackStarted: (() -> Void)?

    init(url: URL) {
        super.init(frame: .zero)
        
        // Check cache and get appropriate URL
        let urlToPlay = VideoCacheManager.shared.getURLToPlay(for: url)
        
        let asset = AVAsset(url: urlToPlay)
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
    
    func pausePlayback() {
        queuePlayer?.pause()
    }
    
    func resumePlayback() {
        // Check if player exists and is ready to play
        guard let player = queuePlayer else { return }
        
        // Only play if not already playing
        if player.timeControlStatus != .playing {
            player.play()
        }
    }
    
    deinit {
        queuePlayer?.removeObserver(self, forKeyPath: "timeControlStatus")
        queuePlayer?.pause()
        queuePlayer = nil
        playerLooper = nil
    }
}
