import SwiftUI
import Vision

// Estrutura simples para os pontos detectados
struct BodyPoint: Identifiable {
    let id = UUID()
    let location: CGPoint
    let name: String
}

@MainActor
class ImageAnalysisViewModel: ObservableObject {
    @Published var detectedPoints: [BodyPoint] = []
    @Published var isProcessing = false
    
    func analyze(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        isProcessing = true
        detectedPoints = []
        
        let request = VNDetectHumanBodyPoseRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        
        Task.detached(priority: .userInitiated) {
            do {
                try handler.perform([request])
                guard let observation = request.results?.first else {
                    await MainActor.run { self.isProcessing = false }
                    return
                }
                
                // Pontos que queremos para postura
                let jointsToTrack: [VNHumanBodyPoseObservation.JointName] = [
                    .nose, .neck, .leftShoulder, .rightShoulder, .leftHip, .rightHip
                ]
                
                let points = jointsToTrack.compactMap { joint -> BodyPoint? in
                    guard let point = try? observation.recognizedPoint(joint),
                          point.confidence > 0.3 else { return nil }
                    
                    // Vision usa (0,0) no canto inferior esquerdo.
                    // SwiftUI usa (0,0) no canto superior esquerdo.
                    return BodyPoint(
                        location: CGPoint(x: point.location.x, y: 1 - point.location.y),
                        name: joint.rawValue.rawValue
                    )
                }
                
                await MainActor.run {
                    self.detectedPoints = points
                    self.isProcessing = false
                }
            } catch {
                print("Erro: \(error)")
                await MainActor.run { self.isProcessing = false }
            }
        }
    }
}
