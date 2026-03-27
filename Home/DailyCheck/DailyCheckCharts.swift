//
//  DailyCheckCharts.swift
//  SeAjeite
//
//  Created by Layza Maria Rodrigues Carneiro on 01/03/26.
//

import SwiftUI
import Charts

struct DailyCheckinChart: View {
    @StateObject private var store = ObservableDailyCheckinStore()
    @State private var selectedChart = 0
    private let chartOptions = ["Hours Sitting", "Pain Level", "Comparative"]

    var body: some View {
        let logs = store.weeklyLogs.sorted { $0.date < $1.date }
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Report")
                .font(.headline)
            
            Picker("Graphic", selection: $selectedChart) {
                ForEach(0..<chartOptions.count, id: \.self) { index in
                    Text(chartOptions[index])
                }
            }
            .pickerStyle(.segmented)
            
            if logs.isEmpty {
                Text("No records this week.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                Chart {
                    switch selectedChart {
                    case 0:
                        ForEach(logs) { log in
                            BarMark(
                                x: .value("Day", log.date, unit: .day),
                                y: .value("Hours Sitting", log.sittingHours)
                            )
                            .foregroundStyle(Color.blue.opacity(0.7))
                        }
                    case 1:
                        ForEach(logs) { log in
                            LineMark(
                                x: .value("Day", log.date, unit: .day),
                                y: .value("Pain Level", log.painLevel)
                            )
                            .foregroundStyle(Color.red)
                            .symbol(Circle())
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                    case 2:
                        ForEach(logs) { log in
                            BarMark(
                                x: .value("Day", log.date, unit: .day),
                                y: .value("Hours Sitting", log.sittingHours)
                            )
                            .foregroundStyle(Color.blue.opacity(0.5))
                            
                            LineMark(
                                x: .value("Day", log.date, unit: .day),
                                y: .value("Pain Level", log.painLevel)
                            )
                            .foregroundStyle(Color.red)
                            .symbol(Circle())
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                    default:
                        ForEach(logs) { log in
                            BarMark(
                                x: .value("Day", log.date, unit: .day),
                                y: .value("Hours Sitting", log.sittingHours)
                            )
                            .foregroundStyle(Color.blue.opacity(0.7))
                        }
                    }
                }
                .frame(height: 250)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
                .animation(.easeInOut, value: selectedChart)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .onAppear {
            store.load()
        }
    }
}

@MainActor
class ObservableDailyCheckinStore: ObservableObject {
    @Published var weeklyLogs: [DailyCheckin] = []
    
    init() {
        load()
    }
    
    func load() {
        weeklyLogs = DailyCheckinStore.shared.weeklyLogs()
    }
    
    func reload() {
        load()
    }
    
    func addCheckin(_ checkin: DailyCheckin) {
        DailyCheckinStore.shared.save(checkin)
        reload()
    }
}
