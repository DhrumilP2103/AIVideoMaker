//
//  ExDate.swift
//  TheHouseRepair
//
//  Created by Kiran Jamod on 27/09/25.
//

import Foundation

extension Date {
    static func getCurrentDateWithTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

