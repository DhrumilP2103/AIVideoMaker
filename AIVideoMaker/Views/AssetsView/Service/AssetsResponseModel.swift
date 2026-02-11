//
//  AssetsResponseModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 11/02/26.
//


import Foundation

struct AssetsResponseModel: Codable {

  var success : Bool?   = nil
  var status  : Int?    = nil
  var message : String? = nil
  var data    : [ResponseVideos]? = []

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
    data    = try values.decodeIfPresent([ResponseVideos].self , forKey: .data    )
 
  }

  init() {

  }

}
