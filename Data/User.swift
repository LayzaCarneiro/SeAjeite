//
//  User.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 28/02/26.
//

import Foundation

struct UserProfile: Codable {
    var name: String
    var age: Int
    var spinalIssue: String
    var isActive: Bool
}

class ProfileStorage {
    private let userKey = "user_profile_data"
    
    func saveProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func loadProfile() -> UserProfile {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return UserProfile(name: "New User", age: 18, spinalIssue: "None", isActive: true)
        }
        return decoded
    }
}
