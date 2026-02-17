//
//  ProfileViewModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 16/02/26.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel: BaseModel {
    private let profileAPIService: ProfileAPIService
    
    @Published var profileResponseData: ProfileResponseData = ProfileResponseData()
    @Published var profileUpdateData: ProfileUpdateData = ProfileUpdateData()
    @Published var profileUpdateSuccess: Bool = false
    
    @Published var name: String = ""
    
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
    
    func updateProfile(appState: NetworkAppState) {
        
        retryAPIs[.profileUpdate] = { [weak self] in
            guard let self else { return }
            self.getProfile(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .profileUpdate
            return
        }
        
        showLoader()
        profileAPIService.updateProfile(name: self.name) { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.profileUpdateSuccess = true
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
    
    func logout(appState: NetworkAppState) {
        
        retryAPIs[.logout] = { [weak self] in
            guard let self else { return }
            self.logout(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .logout
            return
        }
        
        showLoader()
        profileAPIService.logout { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(_):
//                    self.logoutSuccess = true
                    // Clear user data
                    UserDefaults.standard.removeObject(forKey: "bearer_token")
                    UserDefaults.standard.synchronize()
                    // Trigger navigation to home
                    appState.shouldNavigateToHome = true
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

