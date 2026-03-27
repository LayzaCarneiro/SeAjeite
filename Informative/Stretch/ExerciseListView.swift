import SwiftUI

struct StretchExerciseListView: View {
    @Binding var exercises: [Exercise]
    var onComplete: () -> Void
    
    @State private var timeElapsed = 0
    @State private var timerActive = false
    @State private var breatheEffect = 0.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    var body: some View {
        VStack(spacing: 24) {
            
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 200, height: 200)
                    .scaleEffect(1 + (breatheEffect * 0.35))
                    .blur(radius: breatheEffect * 15)
                
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 10)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeElapsed % 60) / 60.0 == 0 && timeElapsed > 0 ? 1.0 : CGFloat(timeElapsed % 60) / 60.0)
                    .stroke(
                        LinearGradient(colors: [.accentColor, .blue.opacity(0.6)], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeElapsed)
                
                VStack(spacing: 4) {
                    Text(timerActive ? (breatheEffect > 0.5 ? "" : "") : "Tap Play")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .textCase(.uppercase)
                    
                    Text(formatTime(timeElapsed))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
            }
            .padding(.top, 40)

            VStack(alignment: .leading) {
                HStack {
                    Text("Your Session")
                        .font(.headline)
                    Spacer()
                    Text("\(exercises.filter({$0.completed}).count)/\(exercises.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($exercises) { $exercise in
                            HStack {
                                Image(systemName: "figure.cooldown")
                                    .foregroundColor(.accentColor)
                                    .padding(8)
                                    .background(Color.accentColor.opacity(0.1))
                                    .clipShape(Circle())

                                Text(exercise.name)
                                    .font(.subheadline)
                                    .strikethrough(exercise.completed) // Riscado se completar
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring()) { exercise.completed.toggle() }
                                }) {
                                    Image(systemName: exercise.completed ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(exercise.completed ? .green : .gray)
                                        .font(.title2)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                            .opacity(exercise.completed ? 0.6 : 1.0)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            HStack(spacing: 16) {
                Button(action: {
                    timerActive.toggle()
                }) {
                    Label(timerActive ? "Pause" : "Play", systemImage: timerActive ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(timerActive ? Color.white : Color.accentColor)
                        .foregroundColor(timerActive ? .accentColor : .white)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.accentColor, lineWidth: 1))
                }

                Button("Finish") {
                    onComplete()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(exercises.allSatisfy({ $0.completed }) ? Color.success : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(16)
                .disabled(!exercises.allSatisfy({ $0.completed }))
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .onReceive(timer) { _ in
            if timerActive {
                timeElapsed += 1
            }
        }
        .onChange(of: timerActive) { active in
            if active {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    breatheEffect = 1.0
                }
            } else {
                withAnimation(.easeInOut(duration: 1)) {
                    breatheEffect = 0.0
                }
            }
        }
    }
}
