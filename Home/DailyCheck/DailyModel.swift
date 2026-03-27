//
//  Model.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 28/02/26.
//

import Foundation

struct DailyCheckin: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let painLevel: Double
    let sittingHours: Double
    
    // to implement
    let morningStretch: Bool
    let postureBreak: Bool
    let eveningWindDown: Bool
    let hydrationGoal: Bool
}
