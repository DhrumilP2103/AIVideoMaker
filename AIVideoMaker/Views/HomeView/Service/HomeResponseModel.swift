//
//  HomeResponseModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 06/02/26.
//


import Foundation

struct HomeResponseModel: Codable {

  var status  : Int?   = nil
  var code    : Int?    = nil
  var message : String? = nil
  var data    : HomeResponseData?   = HomeResponseData()

  enum CodingKeys: String, CodingKey {

    case status  = "status"
    case code    = "code"
    case message = "message"
    case data    = "data"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    status  = try values.decodeIfPresent(Int.self   , forKey: .status  )
    code    = try values.decodeIfPresent(Int.self    , forKey: .code    )
    message = try values.decodeIfPresent(String.self , forKey: .message )
    data    = try values.decodeIfPresent(HomeResponseData.self   , forKey: .data    )
 
  }

  init() {

  }

}

struct HomeResponseData: Codable {

  var categories : [HomeResponseCategories]? = []
  var videos     : [HomeResponseVideos]?     = []

  enum CodingKeys: String, CodingKey {

    case categories = "categories"
    case videos     = "videos"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    categories = try values.decodeIfPresent([HomeResponseCategories].self , forKey: .categories )
    videos     = try values.decodeIfPresent([HomeResponseVideos].self     , forKey: .videos     )
 
  }

  init() {

  }

}

struct HomeResponseCategories: Codable, Identifiable {

  var id   : Int?    = nil
  var name : String? = nil
  var icon : String? = nil

  enum CodingKeys: String, CodingKey {

    case id   = "id"
    case name = "name"
    case icon = "icon"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id   = try values.decodeIfPresent(Int.self    , forKey: .id   )
    name = try values.decodeIfPresent(String.self , forKey: .name )
    icon = try values.decodeIfPresent(String.self , forKey: .icon )
 
  }

  init() {

  }

}

struct HomeResponseVideos: Codable, Identifiable {

  var id         : Int?    = nil
  var categoryId : Int?    = nil
  var title      : String? = nil
  var thumbnail  : String? = nil
  var videoUrl   : String? = nil
  var duration   : String? = nil
  var likes      : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case id         = "id"
    case categoryId = "category_id"
    case title      = "title"
    case thumbnail  = "thumbnail"
    case videoUrl   = "video_url"
    case duration   = "duration"
    case likes      = "likes"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id         = try values.decodeIfPresent(Int.self    , forKey: .id         )
    categoryId = try values.decodeIfPresent(Int.self    , forKey: .categoryId )
    title      = try values.decodeIfPresent(String.self , forKey: .title      )
    thumbnail  = try values.decodeIfPresent(String.self , forKey: .thumbnail  )
    videoUrl   = try values.decodeIfPresent(String.self , forKey: .videoUrl   )
    duration   = try values.decodeIfPresent(String.self , forKey: .duration   )
    likes      = try values.decodeIfPresent(Int.self    , forKey: .likes      )
 
  }

    init(id: Int = 0, categoryId: Int = 0, title: String = "", thumbnail: String = "", videoUrl: String = "", duration: String = "", likes: Int = 0) {
        self.id = id
        self.categoryId = categoryId
        self.title = title
        self.thumbnail = thumbnail
        self.videoUrl = videoUrl
        self.duration = duration
        self.likes = likes
  }

}
