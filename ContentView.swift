//
//  View.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 28/02/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var stretchStorage = StretchStorage()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        TabView {
            HomeView(storage: stretchStorage)
                .tabItem {
                    Label("Home", systemImage: "circle.grid.cross")
                }
            
//            IAView()
//                .tabItem {
//                    Label("IA", systemImage: "brain.head.profile")
//                }
            
            SpineEducationView(storage: stretchStorage)
                .tabItem {
                    Label("Stretching", systemImage: "figure.flexibility")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .fullScreenCover(isPresented: Binding(
                    get: { !hasSeenOnboarding },
                    set: { hasSeenOnboarding = !$0 }
                )) {
                    OnboardingView(showOnboarding: $hasSeenOnboarding)
                }
    }
}
