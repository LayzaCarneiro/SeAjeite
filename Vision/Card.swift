//
//  Card.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 28/02/26.
//

import SwiftUI
import PhotosUI

struct PosturalCheckupCard: View {
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var useCamera = false

    let feedback = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Title & Description
            VStack(spacing: 12) {
                Text("Postural Check-up")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Text("""
Upload a photo to analyze your spinal alignment using our advanced AI technology. Get instant feedback on your posture symmetry.
""")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
            }
            
            // MARK: - Show selected image preview
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(14)
                    .shadow(radius: 5)
            }
            
            // MARK: - Primary Button: Take Photo
            Button {
                useCamera = true
                showingImagePicker = true
                feedback.impactOccurred()
            } label: {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Take Photo")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            
            // MARK: - Secondary Button: Upload Image
            Button {
                useCamera = false
                showingImagePicker = true
                feedback.impactOccurred()
            } label: {
                HStack {
                    Image(systemName: "arrow.up.doc")
                    Text("Upload Image")
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryText)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.3))
                )
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(radius: 10)
        )
        .padding()
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage, useCamera: useCamera)
        }
    }
}

// MARK: - UIImagePickerController Wrapper
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var useCamera: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = useCamera ? .camera : .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
