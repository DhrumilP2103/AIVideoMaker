//
//  ResponseVideos.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 11/02/26.
//


import Foundation

struct ResponseVideos: Codable, Identifiable {

  var id              : Int?    = nil
  var hashKey         : String? = nil
  var userHashKey     : String? = nil
  var categoryHashKey : String? = nil
  var categoryName    : String? = nil
  var title           : String? = nil
  var thumbnail       : String? = nil
  var videoUrl        : String? = nil
  var duration        : String? = nil
  var createdAt       : String? = nil
  var likes           : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case id              = "id"
    case hashKey         = "hash_key"
    case userHashKey     = "user_hash_key"
    case categoryHashKey = "category_hash_key"
    case categoryName    = "category_name"
    case title           = "title"
    case thumbnail       = "thumbnail"
    case videoUrl        = "video_url"
    case duration        = "duration"
    case createdAt       = "created_at"
    case likes           = "likes"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id              = try values.decodeIfPresent(Int.self    , forKey: .id              )
    hashKey         = try values.decodeIfPresent(String.self , forKey: .hashKey         )
    userHashKey     = try values.decodeIfPresent(String.self , forKey: .userHashKey     )
    categoryHashKey = try values.decodeIfPresent(String.self , forKey: .categoryHashKey )
    categoryName    = try values.decodeIfPresent(String.self , forKey: .categoryName    )
    title           = try values.decodeIfPresent(String.self , forKey: .title           )
    thumbnail       = try values.decodeIfPresent(String.self , forKey: .thumbnail       )
    videoUrl        = try values.decodeIfPresent(String.self , forKey: .videoUrl        )
    duration        = try values.decodeIfPresent(String.self , forKey: .duration        )
    createdAt       = try values.decodeIfPresent(String.self , forKey: .createdAt       )
    likes           = try values.decodeIfPresent(Int.self    , forKey: .likes           )
 
  }

    init(id: Int = 0, categoryHashKey: String = "", title: String = "", thumbnail: String = "", videoUrl: String = "", duration: String = "", likes: Int = 0) {
        self.id = id
        self.categoryHashKey = categoryHashKey
        self.title = title
        self.thumbnail = thumbnail
        self.videoUrl = videoUrl
        self.duration = duration
        self.likes = likes
  }

}
