import SwiftUI
import PhotosUI

struct DocumentPickerView: View {
    @Binding var images: [URL] // só imagens
    @State private var showingPicker = false
    @State private var showingPreview = false
    @State private var previewIndex: Int = 0
    
    let feedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Medical Reports / Images")
                .font(.headline)
                .foregroundColor(.primary)
            
            if !images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(images.indices, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Button {
                                    previewIndex = index
                                    showingPreview = true
                                } label: {
                                    if let img = UIImage(contentsOfFile: images[index].path) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                }
                                
                                Button(action: {
                                    images.remove(at: index)
                                    feedback.impactOccurred()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.clipShape(Circle()))
                                }
                                .offset(x: 8, y: -8)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            } else {
                Text("No images selected")
                    .foregroundColor(.secondary)
            }
            
            Button(action: { showingPicker = true; feedback.impactOccurred() }) {
                Text("Select Images")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
        }
        .sheet(isPresented: $showingPicker) {
            PhotoPicker(images: $images)
        }
        .fullScreenCover(isPresented: $showingPreview) {
            if images.indices.contains(previewIndex) {
                ImagePreviewGallery(urls: $images, startIndex: previewIndex)
            }
        }
    }
}

// MARK: - PHPicker
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var images: [URL]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        init(_ parent: PhotoPicker) { self.parent = parent }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { url, error in
                        if let url = url {
                            // Copia para diretório temporário
                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                            try? FileManager.default.removeItem(at: tempURL)
                            do {
                                try FileManager.default.copyItem(at: url, to: tempURL)
                                DispatchQueue.main.async {
                                    self.parent.images.append(tempURL)
                                }
                            } catch {
                                print("Erro ao copiar imagem: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var documentURLs: [URL]
    var allowedTypes: [UTType] = [UTType.image]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.documentURLs.append(contentsOf: urls)
        }
    }
}

// MARK: - Fullscreen Image Preview Gallery
struct ImagePreviewGallery: View {
    @Binding var urls: [URL]
    @State private var currentIndex: Int
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var scale: CGFloat = 1.0
    
    init(urls: Binding<[URL]>, startIndex: Int) {
        self._urls = urls
        _currentIndex = State(initialValue: startIndex)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if urls.indices.contains(currentIndex),
               let img = UIImage(contentsOfFile: urls[currentIndex].path) {
                GeometryReader { geo in
                    ScrollView([.vertical, .horizontal], showsIndicators: false) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width)
                            .scaleEffect(scale)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in scale = value }
                            )
                    }
                }
            } else {
                Text("Image not found")
                    .foregroundColor(.white)
            }
            
            VStack {
                HStack() {
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Text("Delete")
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.redIcon)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Text("Close")
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: { if currentIndex > 0 { currentIndex -= 1; scale = 1 } }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: { if currentIndex < urls.count - 1 { currentIndex += 1; scale = 1 } }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .alert("Are you sure you want to delete this image?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if urls.indices.contains(currentIndex) {
                    urls.remove(at: currentIndex)
                    if currentIndex >= urls.count { currentIndex = max(0, urls.count - 1) }
                    scale = 1
                    if urls.isEmpty { dismiss() }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
