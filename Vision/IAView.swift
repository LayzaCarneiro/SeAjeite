//
//  IAView.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 28/02/26.
//

import SwiftUI

struct IAView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.25),
                    Color.blue.opacity(0.1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            Text("AI Analysis")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.bold)
                        }
                        
                        Text("Analyze your posture using AI-powered image analysis.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // MARK: - Card
                    PosturalCheckupCard()
                }
            }
            .padding()
        }
    }
}

#Preview {
    IAView()
}
