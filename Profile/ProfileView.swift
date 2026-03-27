//
//  ProfileView.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 28/02/26.
//

import SwiftUI
import UniformTypeIdentifiers
import QuickLook

struct ProfileView: View {
    
    @AppStorage("user_name") private var name: String = ""
    @AppStorage("user_age") private var age: String = ""
    @AppStorage("user_weight") private var weight: String = ""
    @AppStorage("user_height") private var height: String = ""
    @AppStorage("has_spine_problem") private var hasSpineProblem: Bool = false
    
    @State private var showingDocumentPicker = false
    @State private var images: [URL] = []
    @State private var showingPreview = false
    
    @State private var spineIssues: [SpineIssue] = [
        SpineIssue(name: "Herniated Disc"),
        SpineIssue(name: "Scoliosis"),
        SpineIssue(name: "Kyphosis"),
        SpineIssue(name: "Lordosis"),
        SpineIssue(name: "Other")
    ]
    
    let feedback = UIImpactFeedbackGenerator(style: .light)
    
    struct SpineIssue {
        let name: String
        var isSelected: Bool = false
    }
    
    var selectedIssueText: String {
        if !hasSpineProblem { return "Healthy Spine" }
        let selected = spineIssues.filter { $0.isSelected }.map { $0.name }
        return selected.isEmpty ? "Spine Issue" : selected.joined(separator: ", ")
    }
    
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
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Profile")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.trailing, 160)
                            .padding(.top, 20)
                        
                        Text("Your data is stored locally and securely")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    PremiumProfileSection(
                        displayName: name.isEmpty ? "Your Name" : name,
                        displayAge: age.isEmpty ? "--" : age,
                        displayIssue: selectedIssueText
                    )
                    
                    // MARK: - Form Card
                    VStack(spacing: 20) {
                        customTextField(title: "Name", placeholder: "Enter your name", text: $name, icon: "person")
                        
                        customTextField(title: "Age", placeholder: "00", text: $age, icon: "calendar", keyboard: .numberPad)
                        
                        HStack(spacing: 15) {
                            customTextField(title: "Weight (kg)", placeholder: "0.0", text: $weight, icon: "scalemass", keyboard: .decimalPad)
                            customTextField(title: "Height (cm)", placeholder: "000", text: $height, icon: "ruler", keyboard: .numberPad)
                        }
                        
                        VStack(spacing: 12) {
                            Toggle(isOn: $hasSpineProblem.animation()) {
                                Label("Spine Condition", systemImage: "figure.walk.arrival")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            if hasSpineProblem {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Select your conditions:")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 5)
                                    
                                    ForEach(spineIssues.indices, id: \.self) { index in
                                        Button(action: {
                                            feedback.impactOccurred()
                                            spineIssues[index].isSelected.toggle()
                                        }) {
                                            HStack {
                                                Text(spineIssues[index].name)
                                                Spacer()
                                                Image(systemName: spineIssues[index].isSelected ? "checkmark.seal.fill" : "circle")
                                                    .foregroundColor(spineIssues[index].isSelected ? .accentColor : .gray)
                                            }
                                            .padding()
                                            .background(spineIssues[index].isSelected ? Color.blue.opacity(0.05) : Color.clear)
                                            .cornerRadius(10)
                                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray4), lineWidth: 0.5))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        
                        DocumentPickerView(images: $images)
                            .padding(.vertical, 5)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 5))
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .padding()
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
    
    @ViewBuilder
    private func customTextField(title: String, placeholder: String, text: Binding<String>, icon: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
