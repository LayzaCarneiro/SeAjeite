import SwiftUI

struct DailyCheckinView: View {

    @State private var discomfortLevel: Double = 0
    @State private var sittingHours: Double = 0

    @State private var morningStretch = false
    @State private var postureBreak = false
    @State private var eveningWindDown = false
    @State private var hydrationGoal = false

    @AppStorage("user_weight") private var userWeight: String = ""

    let feedback = UIImpactFeedbackGenerator(style: .medium)

    var completedGoals: Int {
        [
            morningStretch,
            postureBreak,
            eveningWindDown,
            hydrationGoal
        ].filter { $0 }.count
    }

    var totalGoals: Int { 4 }
    
    var discomfortColor: Color {
        switch discomfortLevel {
        case 0...3: return .accentColor
        case 4...6: return .warning
        default: return .danger
        }
    }

    var sittingColor: Color {
        switch sittingHours {
        case 0...4: return .accentColor
        case 5...6: return .warning
        default: return .danger
        }
    }
    
    var alertMessage: String? {
        if discomfortLevel >= 6 {
            return "Your pain level is high. Consider resting or doing a light stretch."
        }

        if sittingHours >= 6 {
            return "You’ve been sitting for a long time. Take a posture break or stretch."
        }

        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Daily Checklist")
                        .foregroundColor(.primaryText)
                        .font(.headline)

                    Text("Track your symptoms today")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                Label("\(completedGoals)/\(totalGoals)", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.primaryText)
                    .padding(8)
                    .background(Color.blueApp.opacity(0.1))
                    .cornerRadius(12)
            }

            // Discomfort Level
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Discomfort Level", systemImage: "bolt.heart")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    Spacer()
                    Text("\(Int(discomfortLevel))/10")
                        .foregroundColor(discomfortColor)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }

                HStack(spacing: 15) {
                    Button(action: {
                        if discomfortLevel > 0 {
                            discomfortLevel -= 1
                            feedback.impactOccurred() // Haptic
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Decrease discomfort level")

                    Slider(value: $discomfortLevel, in: 0...10, step: 1) { _ in
                        feedback.impactOccurred()
                    }
                    .tint(discomfortColor)
                    .onChange(of: discomfortLevel) { _ in
                        saveToday()
                    }

                    Button(action: {
                        if discomfortLevel < 10 {
                            discomfortLevel += 1
                            feedback.impactOccurred() // Haptic
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Increase discomfort level")
                }
            }
            .padding()
            .background(Color.accentColor.opacity(0.07))
            .cornerRadius(12)

            // Sitting Time
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Sitting Time", systemImage: "figure.seated.side")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    Spacer()
                    Text("\(Int(sittingHours))h")
                        .foregroundColor(sittingColor)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }

                HStack(spacing: 15) {
                    Button(action: {
                        if sittingHours > 0 {
                            sittingHours -= 1
                            feedback.impactOccurred()
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Decrease sitting time")

                    Slider(value: $sittingHours, in: 0...12, step: 1) { _ in
                        feedback.impactOccurred()
                    }
                    .onChange(of: sittingHours) { _ in
                        saveToday()
                    }
                    .tint(sittingColor)

                    Button(action: {
                        if sittingHours < 12 {
                            sittingHours += 1
                            feedback.impactOccurred()
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Increase sitting time")
                }
            }
            .padding()
            .background(Color.accentColor.opacity(0.07))
            .cornerRadius(12)
            
            if let alert = alertMessage {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.danger)

                    Text(alert)
                        .font(.subheadline)
                        .foregroundColor(.danger)

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.danger.opacity(0.1))
                )
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: alertMessage)
            }

            // Checklist
            VStack(alignment: .leading, spacing: 12) {
                Text("Stretches & Goals")
                    .foregroundColor(.primaryText)
                    .font(.headline)

                checklistItem("Morning stretches", isOn: $morningStretch)
                checklistItem("Midday posture break", isOn: $postureBreak)
                checklistItem("Evening wind-down", isOn: $eveningWindDown)
                checklistItem("Hydration goal (\(userWeight.isEmpty ? 2 : (((Double(userWeight) ?? 0) * 35) / 1000))L)", isOn: $hydrationGoal)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 6)
        )
        .onAppear {
            loadSavedData()
        }
    }

    // MARK: - Helpers

    var anyValueChanged: Bool {
        discomfortLevel >= 0 || sittingHours >= 0
    }

    func checklistItem(_ title: String, isOn: Binding<Bool>) -> some View {
        Button {
            isOn.wrappedValue.toggle()
            feedback.impactOccurred()
            saveToday()
        } label: {
            HStack {
                Image(systemName: isOn.wrappedValue ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isOn.wrappedValue ? .accentColor : .gray)

                Text(title)
                    .strikethrough(isOn.wrappedValue)
                    .foregroundColor(isOn.wrappedValue ? .secondaryText : .primaryText)

                Spacer()
            }
        }
    }

    // MARK: - Save / Load

    private func saveToday() {
        let checkin = DailyCheckin(
            date: Date(),
            painLevel: discomfortLevel,
            sittingHours: sittingHours,
            morningStretch: morningStretch,
            postureBreak: postureBreak,
            eveningWindDown: eveningWindDown,
            hydrationGoal: hydrationGoal
        )
        DailyCheckinStore.shared.save(checkin)
    }

    func loadSavedData() {
        guard let saved = DailyCheckinStore.shared.load() else { return }
        discomfortLevel = saved.painLevel
        sittingHours = saved.sittingHours
        morningStretch = saved.morningStretch
        postureBreak = saved.postureBreak
        eveningWindDown = saved.eveningWindDown
        hydrationGoal = saved.hydrationGoal
    }
}
