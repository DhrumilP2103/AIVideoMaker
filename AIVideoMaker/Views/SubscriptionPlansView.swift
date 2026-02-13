//
//  SubscriptionPlansView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

// MARK: - Plan Type Enum
enum PlanType: String, CaseIterable {
    case free = "Free"
    case basic = "Basic"
    case premium = "Premium"
}

// MARK: - Subscription Plan Model
struct SubscriptionPlan {
    let type: PlanType
    let title: String
    let subtitle: String
    let price: Int
    let badge: String?
    let badgeColor: Color
    let features: [String]
    let isCurrentPlan: Bool
}

struct SubscriptionPlansView: View {
    @EnvironmentObject var router: Router
    @State private var selectedPlan: PlanType = .premium
    @Namespace private var animation
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // Plan data
    let plans: [PlanType: SubscriptionPlan] = [
        .free: SubscriptionPlan(
            type: .free,
            title: "Free",
            subtitle: "Perfect for getting started",
            price: 0,
            badge: nil,
            badgeColor: .clear,
            features: [
                "📦 100 credits/month",
                "Standard Customer Support during business hours",
                "Up to 5 drafts daily at a time for a user",
                "Completely published in a new platform",
                "Connect 1 social media business account"
            ],
            isCurrentPlan: true
        ),
        .basic: SubscriptionPlan(
            type: .basic,
            title: "Basic",
            subtitle: "Best for growing creators",
            price: 24,
            badge: "POPULAR",
            badgeColor: .green,
            features: [
                "📦 1,000 credits/month",
                "Unlimited social media profiles across all platforms",
                "Publish 60 posts monthly across all platforms",
                "Create Unlimited posts, threads effortlessly",
                "Visual Content Calendar View of scheduled posts"
            ],
            isCurrentPlan: false
        ),
        .premium: SubscriptionPlan(
            type: .premium,
            title: "Premium",
            subtitle: "For professional creators",
            price: 199,
            badge: "PREMIUM",
            badgeColor: .orange,
            features: [
                "📦 5,000 credits/month",
                "Access to basic AI tools and features on dashboard",
                "Up to 500 active drafts stored securely online",
                "Unlimited drafts Pro plan for maximum flexibility",
                "Zapier integration for automated workflows"
            ],
            isCurrentPlan: false
        )
    ]
    
    var currentPlan: SubscriptionPlan {
        plans[selectedPlan] ?? plans[.free]!
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color._041_C_32,
                    Color(hex: "064663")
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
                        self.router.pop()
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
                    Text("Subscription Plans")
                        .font(Utilities.font(.Bold, size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Crown Icon
                    Button {
                        impactFeedback.impactOccurred()
                        self.router.push(BuyCreditsView(), route: .buyCreditsView)
                    } label: {
                        Image("ic_coin").resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // Tab Selector
                HStack(spacing: 12) {
                    ForEach(PlanType.allCases, id: \.self) { plan in
                        TabButton(
                            title: plan.rawValue,
                            isSelected: selectedPlan == plan,
                            animation: animation
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                impactFeedback.impactOccurred()
                                selectedPlan = plan
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                
                // Plan Card with Swipe Support
                TabView(selection: $selectedPlan) {
                    ForEach(PlanType.allCases, id: \.self) { planType in
                        ScrollView(showsIndicators: false) {
                            if let plan = plans[planType] {
                                PlanCard(plan: plan)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 40)
                            }
                        }
                        .tag(planType)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Utilities.font(.SemiBold, size: 16))
                .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "1A4D5C"))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
        }
    }
}

// MARK: - Plan Card
struct PlanCard: View {
    let plan: SubscriptionPlan
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with Title and Badge
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(plan.title)
                        .font(Utilities.font(.Bold, size: 26))
                        .foregroundColor(.white)
                    
                    Text(plan.subtitle)
                        .font(Utilities.font(.Medium, size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                if let badge = plan.badge {
                    Text(badge)
                        .font(Utilities.font(.Bold, size: 10))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(plan.badgeColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.bottom, 32)
            
            // Price
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("$\(plan.price)")
                    .font(Utilities.font(.Bold, size: 36))
                    .foregroundColor(.white)
                
                Text("/month")
                    .font(Utilities.font(.Medium, size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.bottom, 32)
            
            // Subscribe Button
            Button {
                impactFeedback.impactOccurred()
                // Handle subscription
            } label: {
                HStack(spacing: 8) {
                    Text(plan.isCurrentPlan ? "Current Plan" : "Subscribe Now")
                        .font(Utilities.font(.SemiBold, size: 14))
                        .foregroundColor(.white)
                    
                    if !plan.isCurrentPlan {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(plan.isCurrentPlan ? Color(hex: "1A4D5C") : Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .padding(.bottom, 32)
            
            // Features List
            VStack(alignment: .leading, spacing: 16) {
                ForEach(plan.features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(Utilities.font(.Bold, size: 20))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(feature)
                            .font(Utilities.font(.Medium, size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "0F2A3A"))
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        )
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    SubscriptionPlansView()
}
