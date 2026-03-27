//
//  Calendar.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 01/03/26.
//

import SwiftUI

struct WeeklyActivityView: View {
    @Binding var completedDays: [Int]
    let days = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Activity")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(0..<7) { index in
                    VStack(spacing: 8) {
                        Text(days[index])
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        ZStack {
                            Circle()
                                .fill(completedDays.contains(index + 1) ? Color.blue : Color.gray.opacity(0.1))
                                .frame(width: 35, height: 35)
                            
                            if completedDays.contains(index + 1) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10)
        }
    }
}

extension StretchStorage {
    func completedWeekDays() -> [Int] {
        let calendar = Calendar.current
        var days: Set<Int> = []

        for log in weeklyLogs() {
            let weekday = calendar.component(.weekday, from: log.date) 
            days.insert(weekday)
        }

        return Array(days).sorted()
    }
}
