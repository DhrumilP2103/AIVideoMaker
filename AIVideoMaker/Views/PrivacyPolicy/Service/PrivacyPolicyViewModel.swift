//
//  PrivacyPolicyViewModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 17/02/26.
//

import Foundation
import Combine

class PrivacyPolicyViewModel: BaseModel {
    private let privacyPolicyAPIService: PrivacyPolicyAPIService
    
    @Published var privacyPolicyData: PrivacyPolicyData = PrivacyPolicyData()
    
    init(privacyPolicyAPIService: PrivacyPolicyAPIService = PrivacyPolicyAPIService())
    {
        self.privacyPolicyAPIService = privacyPolicyAPIService
        super.init()
    }
    
    func getPrivacyPolicy(appState: NetworkAppState) {
        
        retryAPIs[.privacy] = { [weak self] in
            guard let self else { return }
            self.getPrivacyPolicy(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .privacy
            return
        }
        
        showLoader()
        privacyPolicyAPIService.getPrivacyPolicy { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.privacyPolicyData = response.data ?? PrivacyPolicyData()
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
