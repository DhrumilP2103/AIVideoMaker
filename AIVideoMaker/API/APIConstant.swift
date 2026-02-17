//
//  APIConstant.swift
//  TheHouseRepair
//
//  Created by Kiran Jamod on 26/09/25.
//


struct APIConstants {
    
    // MARK: - Base URL
    static let baseURL = "https://toxcore.com/ai-video/api/"
    
    // MARK: - API Endpoints
    struct Endpoints {
        static let home = "home"
        static let assets = "assets"
        static let likedVideos = "liked_videos"
        static let googleLogin = "google-login"
        static let profile = "profile"
        static let profileUpdate = "profile/update"
        static let like = "like"
        static let privacy = "privacy"
        static let logout = "logout"
    }
}

