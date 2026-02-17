import SwiftUI
import UIKit
import Combine


// MARK: - HostingController for Any SwiftUI View
/// A custom `UIHostingController` that stores a route identifier.
/// Useful to identify which screen is currently being displayed.
class RouteHostingController: UIHostingController<AnyView> {
    /// The route associated with this hosting controller
    let route: AppRoute

    /// Initialize with a SwiftUI view and its route
    init(rootView: AnyView, route: AppRoute) {
        self.route = route
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

// MARK: - Global Router for Navigation
/// Manages navigation stack programmatically.
/// Can push, pop, or pop to a specific route.
final class Router: ObservableObject {
    /// Weak reference to the UINavigationController used for navigation
    fileprivate weak var nav: UINavigationController?

    /// Set the UINavigationController instance for the router
    func set(navController: UINavigationController) {
        self.nav = navController
    }

    // MARK: - Navigation Methods

    /// Push a new SwiftUI view onto the navigation stack
    /// - Parameters:
    ///   - view: The SwiftUI view to push
    ///   - route: The associated AppRoute for identification
    ///   - animated: Whether the transition is animated
    func push<V: View>(_ view: V, route: AppRoute, animated: Bool = true) {
        guard let nav else { return }

        let vc = RouteHostingController(
            rootView: AnyView(view.environmentObject(self)),
            route: route
        )

        nav.pushViewController(vc, animated: animated)
    }

    /// Pop the top view controller from the navigation stack
    func pop(animated: Bool = true) {
        nav?.popViewController(animated: animated)
    }

    /// Pop to the root view controller
    func popToRoot(animated: Bool = true) {
        nav?.popToRootViewController(animated: animated)
    }

    /// Pop to a specific screen based on route
    /// - Parameter route: The target AppRoute to pop to
    func popTo(_ route: AppRoute, animated: Bool = true) {
        guard let nav else { return }

        if let target = nav.viewControllers.first(where: {
            ($0 as? RouteHostingController)?.route == route
        }) {
            nav.popToViewController(target, animated: animated)
        }
    }
}

// MARK: - Custom UINavigationController
/// A UINavigationController subclass that enables swipe-back gesture
/// and hides the navigation bar for a custom SwiftUI look.
class HostingNavigationController: UINavigationController,
                                   UIGestureRecognizerDelegate,
                                   UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the default navigation bar
        setNavigationBarHidden(true, animated: false)

        // Enable swipe-to-go-back gesture
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
        delegate = self
    }

    /// Allow swipe gesture only if there is more than 1 view controller
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    /// Enable/disable swipe back depending on stack count
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled =
            navigationController.viewControllers.count > 1
    }
}


