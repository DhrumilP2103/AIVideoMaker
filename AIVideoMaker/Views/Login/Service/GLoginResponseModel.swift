//
//  GLoginResponseModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 16/02/26.
//


import Foundation

struct GLoginResponseModel: Codable {

  var success : Bool?   = nil
  var status  : Int?    = nil
  var message : String? = nil
  var data    : GLoginResponseData?   = GLoginResponseData()

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
    data    = try values.decodeIfPresent(GLoginResponseData.self   , forKey: .data    )
 
  }

  init() {

  }

}

struct GLoginResponseData: Codable {

  var token : String? = nil
  var hashKey : String? = nil

  enum CodingKeys: String, CodingKey {

    case token = "token"
    case hashKey = "hash_key"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    token   = try values.decodeIfPresent(String.self , forKey: .token   )
    hashKey = try values.decodeIfPresent(String.self , forKey: .hashKey )
 
  }

  init() {

  }

}
