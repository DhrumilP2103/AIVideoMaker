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
  var videos     : [ResponseVideos]?     = []

  enum CodingKeys: String, CodingKey {

    case categories = "categories"
    case videos     = "videos"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    categories = try values.decodeIfPresent([HomeResponseCategories].self , forKey: .categories )
    videos     = try values.decodeIfPresent([ResponseVideos].self     , forKey: .videos     )
 
  }

  init() {

  }

}

struct HomeResponseCategories: Codable, Identifiable {

  var id      : Int?    = nil
  var hashKey : String? = nil
  var name    : String? = nil
  var icon    : String? = nil

  enum CodingKeys: String, CodingKey {

    case id      = "id"
    case hashKey = "hash_key"
    case name    = "name"
    case icon    = "icon"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id      = try values.decodeIfPresent(Int.self    , forKey: .id      )
    hashKey = try values.decodeIfPresent(String.self , forKey: .hashKey )
    name    = try values.decodeIfPresent(String.self , forKey: .name    )
    icon    = try values.decodeIfPresent(String.self , forKey: .icon    )
 
  }

  init() {

  }

}


