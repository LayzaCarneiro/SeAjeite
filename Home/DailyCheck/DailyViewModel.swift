import SwiftUI

@MainActor
class DailyCheckinStore {
    static let shared = DailyCheckinStore()
    private let key = "daily_checkin_logs"
    
    private init() {}
    
    func save(_ checkin: DailyCheckin) {
        var logs = loadAll()
        if let index = logs.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: checkin.date) }) {
            logs[index] = checkin
        } else {
            logs.append(checkin)
        }
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadAll() -> [DailyCheckin] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([DailyCheckin].self, from: data) else { return [] }
        return decoded
    }
    
    func load() -> DailyCheckin? {
        loadAll().first { Calendar.current.isDateInToday($0.date) }
    }
    
    // Logs da semana atual
    func weeklyLogs() -> [DailyCheckin] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return loadAll().filter { $0.date >= startOfWeek }
    }
}
