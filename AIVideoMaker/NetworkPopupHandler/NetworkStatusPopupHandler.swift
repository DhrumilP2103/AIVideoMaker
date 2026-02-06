import SwiftUI

struct NetworkStatusPopupHandler: ViewModifier {

    @EnvironmentObject var appState: NetworkAppState
    var viewModel: BaseModel

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $appState.isNoInternet) {
//                NoInternetPopUp {
//                    if let api = appState.retryRequestedForAPI,
//                       let retry = viewModel.retryAPIs[api] {
//                        retry()       // ← SAFE: no crash
//                    }
//                }
//                .environmentObject(appState)
            }
//            .fullScreenCover(isPresented: $appState.isAuthExpired) {
//                LoginAgainPopUp().background(BackgroundClearView())
//            }
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
                    .background(.gray.opacity(0.5))
                    .blur(radius: 20)
                    .opacity(appState.isNoInternet || appState.isAuthExpired ? 1 : 0)
                    .animation(.easeInOut, value: appState.isNoInternet || appState.isAuthExpired)
            }
    }
}

extension View {
    func networkStatusPopups(viewModel: BaseModel) -> some View {
        modifier(NetworkStatusPopupHandler(viewModel: viewModel))
    }
}
