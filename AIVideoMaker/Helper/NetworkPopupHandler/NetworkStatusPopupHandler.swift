import SwiftUI

struct NetworkStatusPopupHandler: ViewModifier {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: NetworkAppState
    var viewModel: BaseModel

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $appState.isNoInternet) {
                NoInternetPopUp {
                    if let api = appState.retryRequestedForAPI,
                       let retry = viewModel.retryAPIs[api] {
                        retry()       // ← SAFE: no crash
                    }
                }
                .environmentObject(appState)
            }
//            .navigationDestination(isPresented: $appState.navigateToLogin) {
//                LoginView().toolbar(.hidden)
//            }
            .alert(self.appState.alertTitle, isPresented: $appState.showAlert) {
                Button("OK") { }
            } message: {
                Text(self.appState.alertDescription)
            }
            .overlay {
                ZStack { }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(._041_C_32.opacity(0.5))
                    .blur(radius: 20)
                    .opacity(self.appState.isNoInternet || self.appState.isAuthExpired || self.appState.showConfirmationPopup || self.appState.showLoginSheet || self.appState.isAuthExpired ? 1 : 0)
                    .animation(.easeInOut, value: self.appState.isNoInternet || self.appState.isAuthExpired || self.appState.showConfirmationPopup || self.appState.showLoginSheet || self.appState.isAuthExpired)
            }
//            .blur(radius: self.appState.showLoginSheet ? 2 : 0)
            .sheet(isPresented: $appState.showLoginSheet) {
                LoginSheet()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $appState.isAuthExpired) {
                LoginAgainPopUp {
                    // Clear all UserDefaults (removes bearer_token, user_hash_key, etc.)
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    // Dismiss the popup first, then navigate after it finishes animating
                    appState.isAuthExpired = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // Navigate to Dashboard Home tab (pops nav stack + switches tab)
                        self.router.popToRoot()
                        appState.shouldNavigateToHome = true
                    }
                }
                .environmentObject(appState)
            }
            .overlay(
                ZStack {
                    if appState.showConfirmationPopup {
                        ConfirmationPopup(
                            title: appState.popupTitle,
                            message: appState.popupMessage,
                            icon: appState.popupIcon,
                            confirmActionTitle: appState.popupConfirmTitle,
                            isDestructive: appState.popupIsDestructive,
                            confirmAction: appState.popupAction,
                            dismissAction: {
                                appState.showConfirmationPopup = false
                            }
                        )
                    }
                }
            )
    }
}

extension View {
    func networkStatusPopups(viewModel: BaseModel) -> some View {
        modifier(NetworkStatusPopupHandler(viewModel: viewModel))
    }
}
