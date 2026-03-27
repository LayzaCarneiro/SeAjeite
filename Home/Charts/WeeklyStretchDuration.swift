//
//  WeeklyStretchDuration.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 01/03/26.
//

import SwiftUI
import Charts

// MARK: - Modelo para registro de alongamento diário
struct StretchLog: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let duration: Int
}

// MARK: - Armazenamento de logs
class StretchStorage: ObservableObject {
    @Published var logs: [StretchLog] = []
    @Published var didStretchToday: Bool = false
    private let key = "stretch_logs"
    
    init() {
        loadLogs()
        updateDidStretchToday()
    }
    
    func addLog(duration: Int, date: Date = Date()) {
        logs.append(StretchLog(date: date, duration: duration))
        saveLogs()
        updateDidStretchToday()
    }
    
    private func updateDidStretchToday() {
        let calendar = Calendar.current
        didStretchToday = logs.contains { log in
            calendar.isDateInToday(log.date)
        }
    }
    
    private func saveLogs() {
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func loadLogs() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([StretchLog].self, from: data) {
            logs = decoded
        }
    }
    
    // MARK: - Logs da semana atual
    func weeklyLogs() -> [StretchLog] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return logs.filter { $0.date >= startOfWeek }
    }
    
    // MARK: - Totais por dia da semana (mesmo que zero)
    func weeklyTotals() -> [String: Int] {
        let calendar = Calendar.current
        let days = calendar.shortWeekdaySymbols
        var totals: [String: Int] = [:]
        
        for day in days {
            totals[day] = 0
        }
        
        for log in weeklyLogs() {
            let weekdayIndex = calendar.component(.weekday, from: log.date) - 1
            let day = days[weekdayIndex]
            totals[day, default: 0] += log.duration
        }
        
        return totals
    }
    
    func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
}

struct WeeklyStretchChart: View {
    @ObservedObject var storage: StretchStorage
    
    var body: some View {
        let weeklyData = storage.weeklyTotals()
        let days = Calendar.current.shortWeekdaySymbols
        let totalMinutes = weeklyData.values.reduce(0, +)
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weekly Stretch")
                    .font(.headline)
                Spacer()
                Text("Total: \(totalMinutes) min (\(String(format: "%.1f", Double(totalMinutes)/60))h)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if totalMinutes == 0 {
                Text("You haven't stretched yet this week!")
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Chart {
                    ForEach(days, id: \.self) { day in
                        BarMark(
                            x: .value("Day", day),
                            y: .value("Minutes", weeklyData[day] ?? 0)
                        )
                        .foregroundStyle(Color.accentColor)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 5))
    }
}
