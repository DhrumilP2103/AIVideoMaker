//
//  BaseViewModel.swift
//  InternetDemoApp
//
//  Created by Kiran Jamod on 19/11/25.
//

import Combine


class BaseModel: ObservableObject {

    // API retry closures stored here
    var retryAPIs: [NetworkError : () -> Void] = [:]
}

