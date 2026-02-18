//
//  ResponseVideos.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 11/02/26.
//


import Foundation

struct ResponseVideos: Codable {

    var id: FlexibleInt?
    var hashKey: String?
    var userHashKey: String?
    var categoryHashKey: String?
    var categoryName: String?
    var title: String?
    var videoUrl: String?
    var thumbnailUrl: String?
    var status: String?
    var mediaType: String?
    var requestId: String?
    var text: String?
    var duration: String?
    var aspectRatio: String?
    var likes: FlexibleInt?
    var error: String?
    var isOpen: String?
    var createdAt: String?
    var isLiked: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case hashKey = "hash_key"
        case userHashKey = "user_hash_key"
        case categoryHashKey = "category_hash_key"
        case categoryName = "category_name"
        case title
        case videoUrl = "video_url"
        case thumbnailUrl = "thumbnail_url"
        case status
        case mediaType = "media_type"
        case requestId = "request_id"
        case text
        case duration
        case aspectRatio = "aspect_ratio"
        case likes
        case error
        case isOpen = "is_open"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isLiked = "is_liked"
    }

    // MARK: - Custom Init for Manual Object Creation
//    init(
//        id: Int = 0,
//        categoryHashKey: String = "",
//        title: String = "",
//        thumbnailUrl: String = "",
//        videoUrl: String = "",
//        duration: String = "",
//        likes: Int = 0
//    ) {
//        self.id = FlexibleInt(id)
//        self.categoryHashKey = categoryHashKey
//        self.title = title
//        self.thumbnailUrl = thumbnailUrl
//        self.videoUrl = videoUrl
//        self.duration = duration
//        self.likes = FlexibleInt(likes)
//    }
//
//    // MARK: - SwiftUI Safe ID
//    var identifiableId: Int {
//        id?.value ?? 0
//    }
}
