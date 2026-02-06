//
//  Lib.swift
//  TheHouseRepair
//
//  Created by Kiran Jamod on 27/09/25.
//

import Foundation

public func checkInternet() -> Bool {
    let status = LetsReach().connectionStatus()
    switch status {
    case .unknown, .offline:
        return false
    case .online(.wwan), .online(.wiFi):
        return true
    }

}

func DEBUGLOG(_ value: Any) {
    #if DEBUG
    print(value)
    #endif
}

func DEBUGAPI(_ value: Any) {
    #if DEBUG
    print(value)
    #endif
}
