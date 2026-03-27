//
//  Onboarding.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 01/03/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accentColor.opacity(0.5), Color.accentColor.opacity(0.1), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 180, height: 180)
                        .shadow(color: .black.opacity(0.1), radius: 20)
                    
                    Image(systemName: "circle.grid.cross")
                        .font(.system(size: 80))
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                }
                
                VStack(spacing: 16) {
                    Text("SeAjeite")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text("Your spine deserves care.\nWe help you live without pain.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    OnboardingFeatureRow(icon: "figure.cross.training", title: "Guided Stretches", description: "Quick exercises to relieve tension anywhere.")
                    
                    OnboardingFeatureRow(icon: "brain.head.profile", title: "Body Awareness", description: "Learn to maintain a healthy posture every day.")
                    
                    OnboardingFeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Track Progress", description: "See your consistency and evolution over time.")
                }
                .padding(24)
                .background(Color.white.opacity(0.8))
                .cornerRadius(24)
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        showOnboarding = true
                    }
                }) {
                    Text("Let's Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(16)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
