//
//  GoogleSignInManager.swift
//  Orood
//
//  Created by Kiran Jamod on 09/12/25.
//

import Foundation
import Combine
import GoogleSignIn
import AuthenticationServices // optional

final class GoogleSignInManager: ObservableObject {
    static let shared = GoogleSignInManager()

    // Put your iOS client ID here (from Google Cloud / Firebase)
    private let clientID = "1060960657751-d9pabqcadme85shnqtve8epni4sc4fku.apps.googleusercontent.com"
    @Published var user: GIDGoogleUser?

    private init() {
        // Optionally preconfigure
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }

    // Present sign-in flow. For SwiftUI pass the presenting UIViewController.
    func signIn(presenting viewController: UIViewController, completion: @escaping (Result<GIDGoogleUser, Error>) -> Void) {
        guard GIDSignIn.sharedInstance.configuration != nil else {
            completion(.failure(NSError(domain: "GIDSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "GIDConfiguration not set"])))
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let result = result else {
                completion(.failure(NSError(domain: "GIDSignIn", code: -2, userInfo: [NSLocalizedDescriptionKey: "No user returned"])))
                return
            }
            let user = result.user
            self?.user = user
            completion(.success(user))
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        user = nil
    }
}
