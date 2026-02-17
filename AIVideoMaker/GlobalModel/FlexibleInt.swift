//
//  FlexibleInt.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 17/02/26.
//


import Foundation

// MARK: - Flexible Int (handles Int or String from API)
struct FlexibleInt: Codable {
    let value: String?

    init(_ value: String?) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = "\(intValue)"
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            value = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
