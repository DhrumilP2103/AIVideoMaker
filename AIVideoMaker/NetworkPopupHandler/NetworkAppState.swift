//
//  NetworkAppState.swift
//  InternetDemoApp
//
//  Created by Kiran Jamod on 19/11/25.
//


import SwiftUI
import Combine

final class NetworkAppState: ObservableObject {
    @Published var isNoInternet: Bool = false
    @Published var isInternalServerError: Bool = false
    @Published var isAuthExpired: Bool = false
    @Published var retryRequestedForAPI: NetworkError? = nil
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertDescription: String = ""
    
    // Popup State
    @Published var showConfirmationPopup: Bool = false
    @Published var popupTitle: String = ""
    @Published var popupIcon: String = ""
    @Published var popupMessage: String = ""
    @Published var popupConfirmTitle: String = ""
    @Published var popupIsDestructive: Bool = false
    @Published var popupAction: () -> Void = {}
}
