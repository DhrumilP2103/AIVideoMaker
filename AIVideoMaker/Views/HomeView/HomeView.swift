import SwiftUI
import AVFoundation

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @EnvironmentObject var appState: NetworkAppState
    
    @State private var selectedCategoryId: Int? = nil
    @State private var selectedVideo: HomeResponseVideos?
    @State private var selectedVideoIndex: Int = 0
    @State private var isNavForDetail: Bool = false
    @Namespace private var categoryAnimation
    @Namespace private var videoTransition
    
    var body: some View {
        VStack(spacing: 0) {
            // Premium Top Category Tab Bar
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.homeResponseCategories, id: \.id) { category in
                            CategoryItem(category: category)
                                .id(category.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                .onChange(of: selectedCategoryId) { old, newValue in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            
            // Content Area with 2-Column Video Grid
            TabView(selection: $selectedCategoryId) {
                ForEach(viewModel.homeResponseCategories, id: \.id) { category in
                    ScrollView {
                        let filteredVideos = self.viewModel.homeResponseVideos.filter { $0.categoryId == category.id }
                        let isActive = selectedCategoryId == category.id
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 15),
                                GridItem(.flexible(), spacing: 15)
                            ],
                            spacing: 15
                        ) {
                            ForEach(Array(filteredVideos.enumerated()), id: \.element.id) { videoIndex, video in
                                VideoCard(video: video, isActive: .constant(isActive))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            selectedVideo = video
                                            selectedVideoIndex = videoIndex
                                            isNavForDetail = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .padding(.bottom, 100)
                    }
                    .tag(category.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear() {
            self.viewModel.homeList(appState: self.appState)
        }
        .networkStatusPopups(viewModel: viewModel)
        .onChange(of: appState.retryRequestedForAPI) { _, apiName in
            guard let name = apiName else { return }
            if checkInternet() {
                withAnimation {
                    appState.isNoInternet = false
                    if let retry = viewModel.retryAPIs[name] {
                        retry()
                        appState.retryRequestedForAPI = nil
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isNavForDetail) {
            if selectedVideo != nil, let categoryId = selectedCategoryId {
                let filteredVideos = (viewModel.homeResponseVideos)
                    .filter { $0.categoryId == categoryId }
                VideoReelsView(
                    videos: filteredVideos,
                    startIndex: selectedVideoIndex,
                    animation: videoTransition,
                    isNavForDetail: $isNavForDetail
                )
                .navigationBarHidden(true)
            }
        }
        .onChange(of: viewModel.homeResponseCategories.count) { _, _ in
            if selectedCategoryId == nil,
               let first = viewModel.homeResponseCategories.first {
                selectedCategoryId = first.id
            }
        }
    }
    
    @ViewBuilder
    func CategoryItem(category: HomeResponseCategories) -> some View {
        let isSelected = selectedCategoryId == category.id
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        
        Button {
            impactFeedback.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategoryId = category.id
            }
        } label: {
            HStack(spacing: 8) {
                Text(category.icon ?? "")
                    .font(.system(size: 14))
                
                Text(category.name ?? "Unknown")
                    .font(Utilities.font(isSelected ? .Bold : .Medium, size: 15))
            }
            .foregroundColor(isSelected ? .black : .white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                categoryBackground(isSelected: isSelected)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    private func categoryBackground(isSelected: Bool) -> some View {
        if isSelected {
            Capsule()
                .fill(.white)
                .matchedGeometryEffect(id: "CATEGORY_CAPSULE", in: categoryAnimation)
                .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 4)
        } else {
            Capsule()
                .fill(.white.opacity(0.05))
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
        }
    }
}

#Preview {
    DashBoardView()
}

