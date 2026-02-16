//
//  ProfileViewModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 16/02/26.
//

import Foundation
import Combine

class ProfileViewModel: BaseModel {
    private let profileAPIService: ProfileAPIService
    
    @Published var profileResponseData: ProfileResponseData = ProfileResponseData()
    
    init(profileAPIService: ProfileAPIService = ProfileAPIService())
    {
        self.profileAPIService = profileAPIService
        super.init()
    }
    
    func getProfile(appState: NetworkAppState) {
        
        retryAPIs[.profile] = { [weak self] in
            guard let self else { return }
            self.getProfile(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .profile
            return
        }
        
        showLoader()
        profileAPIService.getProfile { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.profileResponseData = response.data ?? ProfileResponseData()
                case .failure(let error):
                    switch error {
                    case .unAuthorizationError(let message):
                        appState.showAlert = true
                        appState.alertDescription = message
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

