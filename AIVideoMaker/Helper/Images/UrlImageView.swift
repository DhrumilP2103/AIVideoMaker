//
//  UrlImageView.swift
//  OYaar
//
//  Created by MB Infoways on 03/04/24.
//

import SwiftUI
import URLImage

struct UrlImageView: View {
    let imageURL: URL?
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat?
    var contentMode: ContentMode = .fill
    
    init(imageURL: URL?, width: CGFloat?, height: CGFloat?, cornerRadius: CGFloat?, contentMode: ContentMode = .fill) {
        self.imageURL = imageURL
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
    }

    var body: some View {
        ZStack {
            if let imageURL = imageURL {
                URLImage(imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width, height: height)  // Sets the frame size
                        .clipped()  // Ensures that the image is clipped to the frame
                        .roundedCorners(cornerRadius: cornerRadius ?? 0, corners: .allCorners)
                        .contentShape(Rectangle())  // Defines the content shape for interaction
                }
            } else {
                Color.clear  // Placeholder color if imageURL is nil
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius ?? 0)
            }
        }
        .frame(width: width, height: height)  // Sets the ZStack's frame
        .clipped()  // Ensures that any overflowing content is clipped
    }
}
