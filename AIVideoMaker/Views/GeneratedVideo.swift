//
//  GeneratedVideo.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import Foundation

struct GeneratedVideo: Identifiable, Codable {
    var id: Int
    var title: String
    var thumbnail: String?
    var videoUrl: String
    var createdDate: Date
    var templateName: String
    var duration: String
    
    // Helper for date grouping
    var dateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(createdDate) {
            return "Today"
        } else if calendar.isDateInYesterday(createdDate) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: createdDate)
        }
    }
}

// MARK: - Sample Data
extension GeneratedVideo {
    static func getSampleData() -> [GeneratedVideo] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        let fourDaysAgo = calendar.date(byAdding: .day, value: -4, to: today)!
        
        return [
            // Today's videos
            GeneratedVideo(
                id: 1,
                title: "Funny Cat Compilation",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/278610721a821840ln2bpy.mp4",
                createdDate: today,
                templateName: "Comedy Template",
                duration: "0:15"
            ),
            GeneratedVideo(
                id: 2,
                title: "Dance Challenge Video",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/1f1cd900-5535-4ae3-bbe8-c1653495c61e.mp4",
                createdDate: today,
                templateName: "Music Video Template",
                duration: "0:30"
            ),
            GeneratedVideo(
                id: 3,
                title: "Gaming Highlights",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/b2250d8b-35e9-4906-9c21-9ca8068dd9f3.mp4",
                createdDate: today,
                templateName: "Gaming Template",
                duration: "0:20"
            ),
            
            // Yesterday's videos
            GeneratedVideo(
                id: 4,
                title: "Cooking Tutorial Short",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/278610721a821840ln2bpy.mp4",
                createdDate: yesterday,
                templateName: "Tutorial Template",
                duration: "0:25"
            ),
            GeneratedVideo(
                id: 5,
                title: "Motivational Quote Video",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/ab9ddc58-d937-46f7-b61a-276dd57f1aad.mp4",
                createdDate: yesterday,
                templateName: "Inspirational Template",
                duration: "0:12"
            ),
            
            // 2 days ago
            GeneratedVideo(
                id: 6,
                title: "Travel Vlog Highlights",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/video_reel/thumb/19009915.jpg",
                createdDate: twoDaysAgo,
                templateName: "Vlog Template",
                duration: "0:18"
            ),
            GeneratedVideo(
                id: 7,
                title: "Product Review Short",
                thumbnail: nil,
                videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
                createdDate: twoDaysAgo,
                templateName: "Review Template",
                duration: "0:22"
            ),
            GeneratedVideo(
                id: 8,
                title: "Pet Tricks Compilation",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/bd402d3a-aebf-4ab8-9856-970a353b44bc.mp4",
                createdDate: twoDaysAgo,
                templateName: "Comedy Template",
                duration: "0:28"
            ),
            
            // 4 days ago
            GeneratedVideo(
                id: 9,
                title: "Fitness Workout Routine",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/11ac3b14-b99b-436f-9ad8-7aafb2c75440.mp4",
                createdDate: fourDaysAgo,
                templateName: "Fitness Template",
                duration: "0:35"
            ),
            GeneratedVideo(
                id: 10,
                title: "DIY Home Decor Ideas",
                thumbnail: nil,
                videoUrl: "https://appbanter.s3.us-east-1.amazonaws.com/upload/ai_video/videos/11ac3b14-b99b-436f-9ad8-7aafb2c75440.mp4",
                createdDate: fourDaysAgo,
                templateName: "DIY Template",
                duration: "0:24"
            )
        ]
    }
}
