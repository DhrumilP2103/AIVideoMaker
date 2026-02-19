//
//  AssetsViewModel.swift
//  The House Repair
//
//  Created by Kiran Jamod on 23/12/25.
//

import Foundation
import Combine

class AssetsViewModel: BaseModel {
    private let assetsAPIService: AssetsAPIService
    
    @Published var assetsResponseData: [ResponseVideos] = [ResponseVideos]()
    
    init(assetsAPIService: AssetsAPIService = AssetsAPIService())
    {
        self.assetsAPIService = assetsAPIService
        super.init()
    }
    func assetsList(appState: NetworkAppState) {
        
        retryAPIs[.homeList] = { [weak self] in
            guard let self else { return }
            self.assetsList(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .homeList
            return
        }
        
        showLoader()
        assetsAPIService.assetsList() { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.assetsResponseData = response.data ?? [ResponseVideos]()
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

