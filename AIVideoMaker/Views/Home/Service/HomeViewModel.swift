//
//  HomeViewModel.swift
//  The House Repair
//
//  Created by Kiran Jamod on 23/12/25.
//

import Foundation
import Combine

class HomeViewModel: BaseModel {
    private let homeAPIService: HomeAPIService
    
    @Published var homeResponseData: HomeResponseData = HomeResponseData()
    @Published var homeResponseCategories: [HomeResponseCategories] = [HomeResponseCategories]()
    @Published var homeResponseVideos: [ResponseVideos] = [ResponseVideos]()
    
    init(homeAPIService: HomeAPIService = HomeAPIService())
    {
        self.homeAPIService = homeAPIService
        super.init()
    }
    func homeList(appState: NetworkAppState) {
        
        retryAPIs[.homeList] = { [weak self] in
            guard let self else { return }
            self.homeList(appState: appState)
        }
        
        guard checkInternet() else {
            appState.isNoInternet = true
            appState.retryRequestedForAPI = .homeList
            return
        }
        
        showLoader()
        homeAPIService.homeList() { [weak self] result in
            dismissLoader()
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.homeResponseData = response.data ?? HomeResponseData()
                    self.homeResponseCategories = self.homeResponseData.categories ?? [HomeResponseCategories]()
                    self.homeResponseVideos = self.homeResponseData.videos ?? [ResponseVideos]()
//                    Utilities().delay(delay: 0.5) {
//                        if !AppData.shared.isLogin {
//                            appState.showLoginSheet = true
//                        }
//                    }
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

