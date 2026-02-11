//
//  BuyCreditsView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

// MARK: - Credit Package Model
struct CreditPackage: Identifiable {
    let id = UUID()
    let title: String
    let credits: Int
    let bonusCredits: Int?
    let originalPrice: Double
    let finalPrice: Double
    let discountPercentage: Int
    let isPopular: Bool
}

struct BuyCreditsView: View {
    @Environment(\.dismiss) var dismiss
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // Sample current credits
    @State private var currentCredits: Int = 1540
    
    // Credit packages
    let packages: [CreditPackage] = [
        CreditPackage(
            title: "Starter",
            credits: 10,
            bonusCredits: 0,
            originalPrice: 6.99,
            finalPrice: 4.99,
            discountPercentage: 29,
            isPopular: false
        ),
        CreditPackage(
            title: "Popular",
            credits: 50,
            bonusCredits: 5,
            originalPrice: 34.99,
            finalPrice: 19.99,
            discountPercentage: 43,
            isPopular: true
        ),
        CreditPackage(
            title: "Pro",
            credits: 100,
            bonusCredits: 15,
            originalPrice: 69.99,
            finalPrice: 34.99,
            discountPercentage: 50,
            isPopular: false
        ),
        CreditPackage(
            title: "Mega",
            credits: 500,
            bonusCredits: 100,
            originalPrice: 349.99,
            finalPrice: 149.99,
            discountPercentage: 57,
            isPopular: false
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(hex: "0A1F32"),
                    Color(hex: "051420")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    // Back Button
                    Button {
                        impactFeedback.impactOccurred()
                        dismiss()
                    } label: {
                        Image("ic_back").resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(.white.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    // Title
                    Text("Buy Credits")
                        .font(Utilities.font(.Bold, size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Current Credits Card
                        CurrentCreditsCard(credits: currentCredits)
                            .padding(.horizontal, 20)
                        
                        // Credit Packages Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Credit Packages")
                                .font(Utilities.font(.Bold, size: 24))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            // 2-Column Grid
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ],
                                spacing: 16
                            ) {
                                ForEach(packages) { package in
                                    CreditPackageCard(package: package)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Current Credits Card
struct CurrentCreditsCard: View {
    let credits: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Credits")
                    .font(Utilities.font(.Medium, size: 14))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("\(credits)")
                    .font(Utilities.font(.Bold, size: 36))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Ticket Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image("ic_coin").resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "0F2A3A"))
        )
    }
}

// MARK: - Credit Package Card
struct CreditPackageCard: View {
    let package: CreditPackage
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with Title and Badge
            HStack(alignment: .top) {
                Text(package.title)
                    .font(Utilities.font(.Bold, size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Discount Badge
                Text("\(package.discountPercentage)% OFF")
                    .font(Utilities.font(.Bold, size: 9))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.bottom, 16)
            
            
            // Credits
            HStack(spacing: 8) {
                Image("ic_coin").resizable()
                    .frame(width: 18, height: 18)
                
                Text("\(package.credits)")
                    .font(Utilities.font(.Bold, size: 22))
                    .foregroundColor(.white)
                
                Text("credits")
                    .font(Utilities.font(.Medium, size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.bottom, 8)
            
            // Bonus Credits
            if let bonus = package.bonusCredits {
                Text("+ \(bonus) bonus credits")
                    .font(Utilities.font(.Medium, size: 10))
                    .foregroundColor(.green)
                    .padding(.bottom, 12)
            } else {
                Spacer()
                    .frame(height: 12)
            }
            
            // Pricing
            HStack(spacing: 4) {
                Text("$\(String(format: "%.2f", package.finalPrice))")
                    .font(Utilities.font(.Bold, size: 18))
                    .foregroundColor(.white)
                
                Text("$\(String(format: "%.2f", package.originalPrice))")
                    .font(Utilities.font(.Medium, size: 10))
                    .foregroundColor(.white.opacity(0.4))
                    .strikethrough()
                Spacer()
            }
            .padding(.bottom, 12)
            
            // Buy Button
            Button {
                impactFeedback.impactOccurred()
                // Handle purchase
            } label: {
                Text("Buy")
                    .font(Utilities.font(.SemiBold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "1A4D5C"))
                    )
            }
        }
        .frame(height: 200)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "0F2A3A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.clear, lineWidth: 2)
                )
        )
    }
}

#Preview {
    NavigationStack {
        BuyCreditsView()
    }
}
