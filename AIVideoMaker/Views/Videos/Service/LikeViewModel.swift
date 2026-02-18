//
//  LikeViewModel.swift
//  AIVideoMaker
//
//  Created by Kiran Jamod on 17/02/26.
//

import Foundation
import Combine

class LikeViewModel: BaseModel {
    private let likeAPIService: LikeAPIService
    
    @Published var isVideoLiked: Bool = false
    @Published var likeSuccess: Bool = false
    @Published var videoHashKey: String = ""
    
    init(likeAPIService: LikeAPIService = LikeAPIService())
    {
        self.likeAPIService = likeAPIService
        super.init()
    }
    
    func likeVideo(appState: NetworkAppState) {
        
        retryAPIs[.like] = { [weak self] in
            guard let self else { return }
            self.likeVideo(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .like
            return
        }
        
        showLoader()
        likeAPIService.likeVideo(videoHashKey: videoHashKey) { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.likeSuccess = true
                    self.isVideoLiked = response.message == "Liked"
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

