import SwiftUI

// MARK: - Modelo de Exercício
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    var completed: Bool = false
}

// MARK: - Tela de Seleção de Alongamento
struct StretchSelectionView: View {
    
    @State private var selectedTime: Int = 2
    @State private var selectedPosition: String = "Seated"
    @State private var exercises: [Exercise] = []
    @State private var showExercises = false
    @State private var showCompletion = false
    
    @ObservedObject var storage: StretchStorage

    let positions = ["Seated", "Lying down", "Standing"]
    let times = [2, 5, 10]
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Customize your session")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
            
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: getPositionIcon(selectedPosition))
                            .foregroundColor(.accentColor)
                            .font(.headline)
                        Text("Body Position")
                            .font(.headline)
                    }
                    
                    Picker("Position", selection: $selectedPosition) {
                        ForEach(positions, id: \.self) { pos in
                            Text(pos)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(getTimeColor(selectedTime))
                            .font(.headline)
                        Text("Duration")
                            .font(.headline)
                        Spacer()
                        Text("\(selectedTime) min")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    }
                    
                    Picker("Time (min)", selection: $selectedTime) {
                        ForEach(times, id: \.self) { t in
                            Text("\(t)m")
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            
            Button(action: {
                exercises = generateExercises(position: selectedPosition, time: selectedTime)
                showExercises = true
            }) {
                HStack {
                    Text("Start Training")
                        .fontWeight(.bold)
                    Image(systemName: "play.fill")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $showExercises) {
            StretchExerciseListView(exercises: $exercises) {
                showExercises = false
                showCompletion = true
                storage.addLog(duration: selectedTime)
            }
        }
        .alert("Congratulations!", isPresented: $showCompletion) {
            Button("To close", role: .cancel) {}
        } message: {
            Text("You have completed your stretches for the day!")
        }
    }
    
    // MARK: - Helpers Visuais
    
    func getPositionIcon(_ pos: String) -> String {
        switch pos {
        case "Seated": return "figure.mind.and.body"
        case "Lying down": return "figure.yoga"
        case "Standing": return "figure.cooldown"
        default: return "figure.walk"
        }
    }
    
    func getTimeColor(_ time: Int) -> Color {
        switch time {
        case 2: return .green   // Leve
        case 5: return .orange  // Moderado
        case 10: return .red    // Intenso
        default: return .accentColor
        }
    }
    
    // MARK: - Lógica de Exercícios (mantida do seu original)
    func generateExercises(position: String, time: Int) -> [Exercise] {
        var list: [Exercise] = []
        switch position {
        case "Seated":
            if time >= 2 { list.append(Exercise(name: "Finger and wrist extension")) }
            if time >= 5 { list.append(contentsOf: ["Trunk rotation", "Neck rotation"].map { Exercise(name: $0) }) }
            if time >= 10 { list.append(contentsOf: ["Shoulder stretch", "Spinal stretching"].map { Exercise(name: $0) }) }
        case "Lying down":
            if time >= 2 { list.append(Exercise(name: "Deep breathing")) }
            if time >= 5 { list.append(contentsOf: ["Hip rotation", "Knee bend"].map { Exercise(name: $0) }) }
            if time >= 10 { list.append(contentsOf: ["Spinal stretching", "Leg stretch"].map { Exercise(name: $0) }) }
        case "Standing":
            if time >= 2 { list.append(Exercise(name: "Finger and wrist extension")) }
            if time >= 5 { list.append(contentsOf: ["Trunk rotation", "Neck rotation"].map { Exercise(name: $0) }) }
            if time >= 10 { list.append(contentsOf: ["Leg stretch", "Shoulder stretch"].map { Exercise(name: $0) }) }
        default: break
        }
        return list
    }
}
