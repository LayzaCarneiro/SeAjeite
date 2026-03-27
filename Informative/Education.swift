import SwiftUI

// MARK: - Model
struct SpineDetail: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let definition: String
    let symptoms: [String]
    let causes: [String]
    let diagnosis: String
    let treatment: String
    let prevention: String
}

// MARK: - Main Education View
struct SpineEducationView: View {
    
    @ObservedObject var storage: StretchStorage
    @State private var completedDays: [Int] = []

    let conditionsData: [SpineDetail] = [
        SpineDetail(
            name: "Scoliosis",
            icon: "figure.stand",
            color: .blue,
            definition: "A lateral curvature of the spine that most often occurs during the growth spurt just before puberty.",
            symptoms: ["Uneven shoulders", "One shoulder blade appearing more prominent", "Uneven waist or hips"],
            causes: ["Congenital deformities", "Neuromuscular conditions", "Idiopathic (Unknown)"],
            diagnosis: "Physical examination and X-ray imaging (Cobb angle measurement).",
            treatment: "Observation, orthopedic bracing, or physical therapy.",
            prevention: "Regular screenings during growth spurts and core strengthening."
        ),
        SpineDetail(
            name: "Kyphosis",
            icon: "figure.walk",
            color: .indigo,
            definition: "An exaggerated, forward rounding of the upper back, often called hunchback.",
            symptoms: ["Rounded shoulders", "Visible hump on the back", "Spine stiffness"],
            causes: ["Poor posture", "Osteoporosis", "Scheuermann's disease"],
            diagnosis: "Visual inspection and lateral X-ray imaging.",
            treatment: "Postural exercises, physical therapy, or back braces.",
            prevention: "Maintaining good posture and strengthening upper back muscles."
        ),
        SpineDetail(
            name: "Hernia",
            icon: "bolt.fill",
            color: .orange,
            definition: "A herniated disc occurs when the soft center of a spinal disc pushes through a crack in the exterior.",
            symptoms: ["Sharp back pain", "Numbness or tingling", "Muscle weakness in legs"],
            causes: ["Age-related wear (Disc degeneration)", "Improper lifting of heavy objects", "Sudden strain"],
            diagnosis: "Neurological exam and MRI or CT scans.",
            treatment: "Rest, anti-inflammatory medication, and targeted physiotherapy.",
            prevention: "Safe lifting techniques, weight management, and core stability."
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stretch Time")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                        Text("Learn how to take care of your posture")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Daily Habits")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        HStack(alignment: .top, spacing: 12) {
                            HabitCard(title: "Recommended", icon: "checkmark.circle.fill", color: .success, habits: ["Feet flat on floor", "Screen at eye level", "Core exercises"])
                            HabitCard(title: "Avoid", icon: "xmark.circle.fill", color: .danger, habits: ["Crossing legs", "Phone on shoulder", "Slouching"])
                        }
                        .padding(.horizontal)
                    }
                    
                    WeeklyActivityView(completedDays: $completedDays)
                        .padding(.horizontal)

                    NavigationLink(destination: StretchSelectionView(storage: storage)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Stretching")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Pick your style and duration")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Information about Spine Conditions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(conditionsData) { condition in
                                    NavigationLink(destination: SpineDetailView(detail: condition)) {
                                        ConditionCard(
                                            title: condition.name,
                                            symptom: getSymptomPreview(for: condition.name),
                                            icon: condition.icon,
                                            color: condition.color
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.accentColor)
                        Text("This information is for educational purposes. It does not replace professional medical advice.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .padding()
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                completedDays = storage.completedWeekDays()
            }
        }
    }
    
    func getSymptomPreview(for name: String) -> String {
        switch name {
        case "Scoliosis": return "Uneven waist"
        case "Kyphosis": return "Rounded back"
        case "Hernia": return "Sharp leg pain"
        default: return "Learn more"
        }
    }
}

// MARK: - Detail View
struct SpineDetailView: View {
    let detail: SpineDetail
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: detail.icon)
                        .font(.system(size: 40))
                        .foregroundColor(detail.color)
                    
                    Text(detail.name)
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text(detail.definition)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                
                VStack(spacing: 16) {
                    InfoListSection(title: "Common Symptoms", items: detail.symptoms, icon: "exclamationmark.bubble.fill", color: .orange)
                    InfoListSection(title: "Main Causes", items: detail.causes, icon: "bolt.horizontal.circle.fill", color: .purple)
                    InfoSection(title: "How it's Diagnosed", content: detail.diagnosis, icon: "doc.text.magnifyingglass", color: .green)
                    InfoSection(title: "Treatments", content: detail.treatment, icon: "cross.case.fill", color: .red)
                    InfoSection(title: "Prevention", content: detail.prevention, icon: "shield.fill", color: .blue)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - UI Components
struct InfoSection: View {
    let title: String; let content: String; let icon: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon).font(.headline).foregroundColor(color)
            Text(content).font(.subheadline).foregroundColor(.primary.opacity(0.8)).lineSpacing(4)
        }
        .padding().frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground)).cornerRadius(16).shadow(color: .black.opacity(0.02), radius: 5)
    }
}

struct InfoListSection: View {
    let title: String; let items: [String]; let icon: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon).font(.headline).foregroundColor(color)
            VStack(alignment: .leading, spacing: 6) {
                ForEach(items, id: \.self) { item in
                    Text("• \(item)").font(.subheadline).foregroundColor(.primary.opacity(0.8))
                }
            }
        }
        .padding().frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground)).cornerRadius(16).shadow(color: .black.opacity(0.02), radius: 5)
    }
}

struct HabitCard: View {
    let title: String; let icon: String; let color: Color; let habits: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon).font(.caption).fontWeight(.bold).foregroundColor(color)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(habits, id: \.self) { habit in
                    Text("• \(habit)").font(.caption2).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding().frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(color.opacity(0.05)).cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.1), lineWidth: 1))
    }
}

struct ConditionCard: View {
    let title: String; let symptom: String; let icon: String; let color: Color
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 24)).foregroundColor(color)
                .frame(width: 50, height: 50).background(color.opacity(0.1)).clipShape(Circle())
            VStack(spacing: 4) {
                Text(title).font(.subheadline).fontWeight(.bold).foregroundColor(.primary)
                Text(symptom).font(.caption2).foregroundColor(.secondary)
            }
        }
        .frame(width: 120, height: 140).background(Color(.systemBackground)).cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

