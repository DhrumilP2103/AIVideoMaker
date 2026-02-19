//
//   LikedVideosViewModel.swift
//  The House Repair
//
//  Created by Kiran Jamod on 23/12/25.
//

import Foundation
import Combine
import SwiftUI

class GLoginViewModel: BaseModel {
    private let gLoginAPIService: GLoginAPIService
    
    @Published var gLoginResponseData: GLoginResponseData = GLoginResponseData()
    @Published var tokenString: String = ""
    @Published var handleLoginSuccess: (() -> Void)?
    init(gLoginAPIService: GLoginAPIService = GLoginAPIService())
    {
        self.gLoginAPIService = gLoginAPIService
        super.init()
    }
    
    func gLogin(appState: NetworkAppState) {
        
        retryAPIs[.gLogin] = { [weak self] in
            guard let self else { return }
            self.gLogin(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .gLogin
            return
        }
        
        showLoader()
        gLoginAPIService.gLogin(tokenString: self.tokenString) { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    let data = response.data ?? GLoginResponseData()
                    UserDefaults.standard.setValue(data.token ?? "", forKey: "bearer_token")
                    UserDefaults.standard.setValue(data.hashKey ?? "", forKey: "user_hash_key")
                    self.gLoginResponseData = data
                    self.handleLoginSuccess?()
                case .failure(let error):
                    switch error {
                    case .unAuthorizationError(let message):
                        appState.isAuthExpired = true
                    case .internalServerError(_):
                        appState.isInternalServerError = true
                    case .network(let message):
                        DEBUGLOG(message)
                    case .unexpected(let message):
                        DEBUGLOG(message)
                    }
                }
            }
        }
    }
    
}

