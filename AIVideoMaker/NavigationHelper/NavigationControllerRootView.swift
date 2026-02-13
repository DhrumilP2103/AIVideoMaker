//
//  NavigationControllerRootView.swift
//  The House Repair
//
//  Created by Kiran Jamod on 26/12/25.
//

import SwiftUI


// MARK: - SwiftUI Wrapper for UINavigationController
/// A UIViewControllerRepresentable to embed UINavigationController in SwiftUI.
struct NavigationControllerRootView: UIViewControllerRepresentable {
    @ObservedObject var router: Router
    @ObservedObject var signInManager = GoogleSignInManager.shared

    func makeUIViewController(context: Context) -> UINavigationController {
        // Root screen is HomeView
        let root = RouteHostingController(
            rootView: AnyView(
                ContentView()
                    .environmentObject(router)
                    .environmentObject(signInManager)
            ),
            route: .contentView
        )

        // Use custom navigation controller
        let nav = HostingNavigationController(rootViewController: root)
        nav.setNavigationBarHidden(true, animated: false)

        // Provide nav controller reference to Router
        router.set(navController: nav)
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No dynamic updates needed here
    }
}
