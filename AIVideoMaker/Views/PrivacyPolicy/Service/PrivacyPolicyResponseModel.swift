//
//  PrivacyPolicyResponseModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 17/02/26.
//


import Foundation

struct PrivacyPolicyResponseModel: Codable {

  var success : Bool?   = nil
  var status  : Int?    = nil
  var message : String? = nil
  var data    : PrivacyPolicyData? = PrivacyPolicyData()

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
    data    = try values.decodeIfPresent(PrivacyPolicyData.self , forKey: .data )
  }

  init() { }
}

struct PrivacyPolicyData: Codable {

  var policy : String? = nil

  enum CodingKeys: String, CodingKey {

    case policy = "policy"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    policy = try values.decodeIfPresent(String.self , forKey: .policy )
  }

  init() { }
}
