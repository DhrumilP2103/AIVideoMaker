//
//  LikedVideosResponseModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 11/02/26.
//


import Foundation

struct LikedVideosResponseModel: Codable {

  var success : Bool?   = nil
  var status  : Int?    = nil
  var message : String? = nil
  var data    : LikedVideosData?   = LikedVideosData()

  enum CodingKeys: String, CodingKey {

    case success = "success"
    case status  = "status"
    case message = "message"
    case data    = "data"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    success = try values.decodeIfPresent(Bool.self   , forKey: .success )
    status  = try values.decodeIfPresent(Int.self    , forKey: .status  )
    message = try values.decodeIfPresent(String.self , forKey: .message )
    data    = try values.decodeIfPresent(LikedVideosData.self   , forKey: .data    )
 
  }

  init() {

  }

}

struct LikedVideosData: Codable {

  var videos : [ResponseVideos]? = []

  enum CodingKeys: String, CodingKey {

    case videos = "videos"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    videos = try values.decodeIfPresent([ResponseVideos].self , forKey: .videos )
 
  }

  init() {

  }

}
