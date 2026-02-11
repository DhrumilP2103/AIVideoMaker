import SwiftUI
import Foundation
import Mantis


struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
//    @Binding var selectedVideoURL: URL?
//    @Binding var selectedImagePath: String?
    var isCropped: Bool = true
    @State var isSelectVideo: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    var videoSizeLimitMB: Double = 50

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = isSelectVideo ? ["public.image", "public.movie"] : ["public.image"]
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
        func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
            
        }
        
        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
            
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController,
                                       cropped: UIImage,
                                       transformation: Mantis.Transformation,
                                       cropInfo: Mantis.CropInfo) {
            
            // Save cropped image
            parent.selectedImage = cropped
//            parent.selectedVideoURL = nil

//            if let imagePath = saveImageToTemporaryDirectory(image: cropped) {
//                parent.selectedImagePath = imagePath
//            } else {
//                parent.selectedImagePath = nil
//            }

            // Dismiss cropper + picker
            cropViewController.dismiss(animated: true)
            pickerRef?.dismiss(animated: true)

            parent.presentationMode.wrappedValue.dismiss()
        }

        

        let parent: ImagePicker
        var pickerRef: UIImagePickerController?

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // MARK: - PICKER RESULT
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            self.pickerRef = picker

            // ---- IMAGE PICKED ----
            if let userSelectedImage = info[.originalImage] as? UIImage {

                if parent.isCropped {
                    // Open cropper immediately
                    openCropper(image: userSelectedImage, picker: picker)
                } else {
                    // Return original image without cropping
                    parent.selectedImage = userSelectedImage
//                    parent.selectedVideoURL = nil
                    
//                    if let path = saveImageToTemporaryDirectory(image: userSelectedImage) {
//                        parent.selectedImagePath = path
//                    } else {
//                        parent.selectedImagePath = nil
//                    }
                    
                    parent.presentationMode.wrappedValue.dismiss()
                }

                return
            }


            // ---- VIDEO PICKED ----
            if let mediaURL = info[.mediaURL] as? URL {
                let fileSizeMB = getFileSizeInMB(at: mediaURL)
                if fileSizeMB > parent.videoSizeLimitMB {
                    showAlert(picker, title: "Video Too Large",
                              message: "The selected video exceeds the size limit of \(parent.videoSizeLimitMB) MB.")
                    return
                }

//                parent.selectedVideoURL = mediaURL
                parent.selectedImage = nil
//                parent.selectedImagePath = nil
                parent.presentationMode.wrappedValue.dismiss()
            }
        }

        // MARK: - CROP UI
        private func openCropper(image: UIImage, picker: UIImagePickerController) {

            let cropViewController = Mantis.cropViewController(image: image)
            cropViewController.delegate = self
            cropViewController.modalPresentationStyle = .overFullScreen
            picker.present(cropViewController, animated: true)
        }

        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
            cropViewController.dismiss(animated: true)
        }

        // MARK: - CANCEL PICKER
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        // MARK: - HELPERS
        private func saveImageToTemporaryDirectory(image: UIImage) -> String? {
            let imageData = image.jpegData(compressionQuality: 1.0)
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = tempDirectory.appendingPathComponent(fileName)

            do {
                try imageData?.write(to: fileURL)
                return fileURL.path
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }

        private func getFileSizeInMB(at url: URL) -> Double {
            if let size = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? UInt64 {
                return Double(size) / (1024 * 1024)
            }
            return 0
        }

        private func showAlert(_ picker: UIImagePickerController, title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            picker.present(alert, animated: true)
        }
    }

    typealias UIViewControllerType = UIImagePickerController
}

