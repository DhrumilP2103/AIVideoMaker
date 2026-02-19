//
//  LoginAgainPopUp.swift
//  NexTrac
//
//  Created by MB Infoways on 09/06/25.
//

import SwiftUI

struct LoginAgainPopUp: View {
    
    var loginAgain: (() -> ())?
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 12){
                        Text("Login again!")
                            .font(Utilities.font(.SemiBold, size: 18))
                            .foregroundColor(.white)
                        
//                        Image(.icLoginAgain)
//                            .resizable()
//                            .frame(width: 18, height: 18)
                        
                        Spacer()
                    }
                    .padding(.horizontal,24)
                    .padding(.top, 36)
                    .padding(.bottom, 6)
                    
                    HStack {
                        Text("We have noticed that you logged in earlier with different device. please login again to continue")
                            .font(Utilities.font(.Medium, size: 14))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                    .padding(.horizontal,24)
                    
                    Spacer()
                    Button {
                        loginAgain?()
                    } label: {
                        ZStack {
                            Text("Login Again")
                                .font(Utilities.font(.SemiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity,maxHeight: .infinity)
                        }
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.1))
                        )
                        .mask { RoundedRectangle(cornerRadius: 12) }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 46)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(
                    LinearGradient(
                        colors: [
                            Color._041_C_32,
                            Color(hex: "064663")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .mask { RoundedRectangle(cornerRadius: 24) }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundClearView())
    }
}

#Preview {
    LoginAgainPopUp()
}
