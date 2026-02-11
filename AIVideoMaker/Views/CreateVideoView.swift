//
//  CreateVideoView.swift
//  AIVideoMaker
//
//  Created by Antigravity on 09/02/26.
//

import SwiftUI

struct CreateVideoView: View {
    let video: ResponseVideos
    
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var selectedImagePath: String?
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isGenerating = false
    @Environment(\.dismiss) var dismiss
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            // Premium Background
            ZStack {
                LinearGradient(
                    colors: [
                        Color._041_C_32,
                        Color(hex: "064663")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                CustomHeaderView()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Template Info Card
                        TemplateInfoCard()
                        
                        // Image Upload Section
                        ImagePreviewSection()
                        
                        // Upload Options
                        UploadOptionsSection()
                        
                        // Generate Button
                        GenerateButtonSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(
                sourceType: imagePickerSourceType,
                selectedImage: $selectedImage,
            )
        }
    }
    
    // MARK: - Custom Header
    @ViewBuilder
    func CustomHeaderView() -> some View {
        HStack {
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
            .buttonStyle(ScaleButtonStyle())
            
            Spacer()
            
            Text("Create Video")
                .font(Utilities.font(.Bold, size: 20))
                .foregroundColor(.white)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
//        .padding(.top, 50)
        .padding(.bottom, 15)
    }
    
    // MARK: - Template Info Card
    @ViewBuilder
    func TemplateInfoCard() -> some View {
        HStack(spacing: 15) {
            // Template Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image("ic_film").resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title ?? "Template")
                    .font(Utilities.font(.Bold, size: 16))
                    .foregroundColor(.white)
                
                Text("Upload an image to create your video")
                    .font(Utilities.font(.Medium, size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
        }
    }
    
    // MARK: - Image Preview Section
    @ViewBuilder
    func ImagePreviewSection() -> some View {
        VStack(spacing: 15) {
            Text("Upload Image")
                .font(Utilities.font(.Bold, size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.05))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    }
                
                if let image = selectedImage {
                    // Image Preview
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(width: ScreenSize.SCREEN_WIDTH - 40, height: 350)
                        .clipped()
                        .cornerRadius(20)
                        .overlay(alignment: .topTrailing) {
                            // Remove Button
                            Button {
                                impactFeedback.impactOccurred()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedImage = nil
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .padding(12)
                        }
                } else {
                    // Empty State
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image("ic_image").resizable().renderingMode(.template)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        VStack(spacing: 5) {
                            Text("No Image Selected")
                                .font(Utilities.font(.Bold, size: 16))
                                .foregroundColor(.white)
                            
                            Text("Choose from gallery or take a photo")
                                .font(Utilities.font(.Medium, size: 13))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .frame(height: 350)
                }
            }
            .frame(width: ScreenSize.SCREEN_WIDTH - 40, height: 350)
        }
    }
    
    // MARK: - Upload Options Section
    @ViewBuilder
    func UploadOptionsSection() -> some View {
        HStack(spacing: 15) {
            // Gallery Button
            Button {
                impactFeedback.impactOccurred()
                imagePickerSourceType = .photoLibrary
                showImagePicker = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                    
                    Text("Gallery")
                        .font(Utilities.font(.SemiBold, size: 15))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.15), lineWidth: 1)
                        }
                }
            }
            .buttonStyle(ScaleButtonStyle())
            
            // Camera Button
            Button {
                impactFeedback.impactOccurred()
                imagePickerSourceType = .camera
                showImagePicker = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.title3)
                    
                    Text("Camera")
                        .font(Utilities.font(.SemiBold, size: 15))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.15), lineWidth: 1)
                        }
                }
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    
    // MARK: - Generate Button Section
    @ViewBuilder
    func GenerateButtonSection() -> some View {
        VStack(spacing: 15) {
            // Credit Info
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Video generation costs 4 credits")
                    .font(Utilities.font(.Medium, size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Generate Button
            Button {
                impactFeedback.impactOccurred()
                generateVideo()
            } label: {
                HStack(spacing: 12) {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        Text("Generating...")
                    } else {
//                        Image(systemName: "wand.and.stars")
//                            .font(.title3)
                        if selectedImage == nil{
//                            Text(selectedImage == nil ? "Select Image First" :"Generate Video")
                            Text("Select Image First")
                                .font(Utilities.font(.Bold, size: 16))
                                .foregroundStyle(.white)
                        } else {
                            HStack(spacing: 4) {
                                Image("ic_coin").resizable()
                                    .frame(width: 16, height: 16)
                                Text("4")
                                    .font(Utilities.font(.Bold, size: 16))
                                    .foregroundStyle(.black)
                            }
                        }
                        
                        
//                        Text("•")
//                            .font(Utilities.font(.Bold, size: 16))
                        
                        
                    }
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background {
                    Capsule()
                        .fill(selectedImage == nil ? Color.white.opacity(0.3) : Color.white)
//                        .shadow(color: selectedImage == nil ? .clear : .white.opacity(0.3), radius: 15, x: 0, y: 8)
                }
            }
            .disabled(selectedImage == nil || isGenerating)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.top, 10)
    }
    
    // MARK: - Generate Video Action
    private func generateVideo() {
        guard selectedImage != nil else { return }
        
        isGenerating = true
        
        // TODO: Implement actual video generation API call
        // For now, simulate a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isGenerating = false
            // Show success message or navigate to result
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        CreateVideoView(video: ResponseVideos())
    }
}
