//
//  ImageViewerRemote.swift
//  NexTrac
//
//  Created by MB Infoways on 25/07/25.
//


import SwiftUI
import UIKit
import URLImage
import Combine
//import Zoomable

@available(iOS 13.0, *)
public struct ImageViewerRemote: View {
    @Binding var viewerShown: Bool
    @Binding var imageURL: String
    @State var httpHeaders: [String: String]?
    @State var disableCache: Bool?
    @State var caption: Text?
    @State var isShowCloseButton: Bool?
    
    var aspectRatio: Binding<CGFloat>?
    
    @State var dragOffset: CGSize = CGSize.zero
    @State var dragOffsetPredicted: CGSize = CGSize.zero
    
    @ObservedObject var loader: ImageLoader
    
    public init(imageURL: Binding<String>, viewerShown: Binding<Bool>, aspectRatio: Binding<CGFloat>? = nil, disableCache: Bool? = nil, caption: Text? = nil, isShowCloseButton: Bool? = false) {
        _imageURL = imageURL
        _viewerShown = viewerShown
        _disableCache = State(initialValue: disableCache)
        self.aspectRatio = aspectRatio
        _caption = State(initialValue: caption)
        _isShowCloseButton = State(initialValue: isShowCloseButton)
        loader = ImageLoader(url: imageURL)
    }
    
    @ViewBuilder
    public var body: some View {
        VStack {
            if(viewerShown && imageURL.count > 0) {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            if self.isShowCloseButton ?? false {
                                Button(action: { self.viewerShown = false }) {
                                    ZStack {
                                        Image(systemName: "xmark")
                                            .foregroundColor(Color(UIColor.white))
                                            .font(.system(size: UIFontMetrics.default.scaledValue(for: 20)))
                                    }.frame(width: 40, height: 40)
                                        .background(.gray.opacity(0.8))
                                        .roundedCorners(cornerRadius: 20, corners: .allCorners)
                                }.buttonStyle(NoTapAnimationStyle())
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .zIndex(2)
                    
                    VStack {
                        ZStack {
                            if(self.disableCache == nil || self.disableCache == false) {
                                URLImage(URL(string: self.imageURL) ?? URL(string: "https://via.placeholder.com/150.png")!, content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(self.aspectRatio?.wrappedValue, contentMode: .fit)
                                        .zoomable()
                                })
                            }
                            else {
                                if loader.image != nil {
                                    Image(uiImage: loader.image!)
                                        .resizable()
                                        .aspectRatio(self.aspectRatio?.wrappedValue, contentMode: .fit)
                                        .zoomable()
                                }
                                else {
                                    Text("")
                                }
                            }
                            
                            if(self.caption != nil) {
                                VStack {
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            self.caption
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12, opacity: (1.0 - Double(abs(self.dragOffset.width) + abs(self.dragOffset.height)) / 1000)).edgesIgnoringSafeArea(.all))
                    .zIndex(1)
                }
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                .onAppear() {
                    self.dragOffset = .zero
                    self.dragOffsetPredicted = .zero
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: Binding<String>
    private var cancellable: AnyCancellable?
    
    func getURLRequest(url: String) -> URLRequest {
        let url = URL(string: url) ?? URL(string: "https://via.placeholder.com/150.png")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request;
    }
    
    init(url: Binding<String>) {
        self.url = url
        
        if(url.wrappedValue.count > 0) {
            load()
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: getURLRequest(url: self.url.wrappedValue))
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
