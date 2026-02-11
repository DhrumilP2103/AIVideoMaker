//
//   LikedVideosViewModel.swift
//  The House Repair
//
//  Created by Kiran Jamod on 23/12/25.
//

import Foundation
import Combine

class LikedVideosViewModel: BaseModel {
    private let likedVideosAPIService: LikedVideosAPIService
    
    @Published var likedVideosData: [ResponseVideos] = [ResponseVideos]()
    
    init(likedVideosAPIService: LikedVideosAPIService = LikedVideosAPIService())
    {
        self.likedVideosAPIService = likedVideosAPIService
        super.init()
    }
    func likedVideosList(appState: NetworkAppState) {
        
        retryAPIs[.homeList] = { [weak self] in
            guard let self else { return }
            self.likedVideosList(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .homeList
            return
        }
        
        showLoader()
        likedVideosAPIService.likedVideosList() { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.likedVideosData = response.data?.videos ?? [ResponseVideos]()
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

