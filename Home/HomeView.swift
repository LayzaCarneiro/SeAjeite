import SwiftUI

struct HomeView: View {

    @AppStorage("user_name") private var userName: String = ""
    @State private var showIcons = false
    @ObservedObject var storage: StretchStorage
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accentColor.opacity(0.3), Color.accentColor.opacity(0.07), .white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SeAjeite")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.trailing, 180)
                        Text("Welcome, \(userName.isEmpty ? "Caterpillar" : userName)! How’s your posture today?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // MARK: - Avatar + Icons
                    ZStack {
                        icon(system: "figure.mind.and.body", color: .redIcon)
                            .offset(x: -120, y: -40)
                            .opacity(showIcons ? 1 : 0)
                            .scaleEffect(showIcons ? 1 : 0.3)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: showIcons)
                        
                        icon(system: "figure.flexibility", color: .blueIcon)
                            .offset(x: 120, y: -30)
                            .opacity(showIcons ? 1 : 0)
                            .scaleEffect(showIcons ? 1 : 0.3)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: showIcons)
                        
                        icon(system: "figure.cooldown", color: .orangeIcon)
                            .offset(x: -100, y: 90)
                            .opacity(showIcons ? 1 : 0)
                            .scaleEffect(showIcons ? 1 : 0.3)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: showIcons)
                        
                        icon(system: "figure.yoga", color: .purpleIcon)
                            .offset(x: 110, y: 100)
                            .opacity(showIcons ? 1 : 0)
                            .scaleEffect(showIcons ? 1 : 0.3)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.4), value: showIcons)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.accentColor)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(radius: 10)
                            )
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 70)
                    
                    DailyCheckinView()
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Progress")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)

                        VStack(spacing: 20) {
                            WeeklyStretchChart(storage: storage)
                            DailyCheckinChart()
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
        .onAppear {
            showIcons = true
        }
    }

    // MARK: - Icon helper
    func icon(system: String, color: Color) -> some View {
        Image(systemName: system)
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .background(
                Circle()
                    .fill(color)
            )
            .shadow(radius: 5)
    }
}
