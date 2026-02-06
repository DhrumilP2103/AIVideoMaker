//
//  APIError.swift
//  The House Repair
//
//  Created by Kiran Jamod on 29/12/25.
//

import Foundation

enum APIError: Error {
    case unAuthorizationError(String)
    case internalServerError(String)
    case network(String)
    case unexpected(String)
}
