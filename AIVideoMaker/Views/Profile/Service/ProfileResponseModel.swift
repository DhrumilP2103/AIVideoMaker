//
//  ProfileResponseModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 16/02/26.
//


import Foundation

struct ProfileResponseModel: Codable {

  var success : Bool?   = nil
  var status  : Int?    = nil
  var message : String? = nil
  var data    : ProfileResponseData?   = ProfileResponseData()

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
    data    = try values.decodeIfPresent(ProfileResponseData.self   , forKey: .data    )
 
  }

  init() {

  }

}

struct ProfileResponseData: Codable {

  var name         : String? = nil
  var email        : String? = nil
  var profileImage : String? = nil

  enum CodingKeys: String, CodingKey {

    case name         = "name"
    case email        = "email"
    case profileImage = "profile_image"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    name         = try values.decodeIfPresent(String.self , forKey: .name         )
    email        = try values.decodeIfPresent(String.self , forKey: .email        )
    profileImage = try values.decodeIfPresent(String.self , forKey: .profileImage )
 
  }

  init() {

  }

}
