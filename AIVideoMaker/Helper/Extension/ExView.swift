//
//  ExView.swift
//  CRM
//
//  Created by Kiran Jamod on 14/02/24.
//

import Foundation
import SwiftUI
//import LPSnackbar
//import BiometricAuthentication


///Use For Transferent Background Color
struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

func showLoader(){
    DispatchQueue.main.async(execute: {
        KRProgressHUD.set(activityIndicatorViewColors: [UIColor(named: "041C32") ?? UIColor.cyan ])
        KRProgressHUD.show()
    })
}
func dismissLoader(){
    DispatchQueue.main.async(execute: {
        KRProgressHUD.dismiss()
    })
}
//func showSnackBar(with message: String) {
//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//        let snack = LPSnackbar(title: message, buttonTitle: nil)
//        // UILabel expects UIFont, not SwiftUI.Font
//        snack.view.titleLabel.font = UIFont(name: Utilities.fontName.lexendSemiBold, size: 12) ?? UIFont.systemFont(ofSize: 12)
//        snack.view.titleLabel.textColor = UIColor.white
//        snack.view.backgroundColor = UIColor(named: "394A5F")
//        snack.show(displayDuration: 3.0, animated: true)
//    }
//}

//func checkForBioMetric(completion : @escaping (String,Bool) -> ()){
//    BioMetricAuthenticator.authenticateWithPasscode(reason: "message") { (result) in
//        switch result {
//        case .success( _):
//            completion("success",true)
//            break
//            // passcode authentication success
//        case .failure(let error):
//            if error == .passcodeNotSet{
//                completion("passcodeNotSet",false)
//            }else{
//                completion("\(error.localizedDescription)",false)
//            }
//            
//            break
//            
//        }
//    }
//}

extension View {
    func roundedCorners(cornerRadius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(cornerRadius: cornerRadius, corners: corners))
    }
}

struct RoundedCorners: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

extension View {
    func getHeightWidth(size: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ViewHeightPreferenceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(ViewHeightPreferenceKey.self, perform: size)
    }
}

struct ViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

func openSettings() {
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL)
    }
}
