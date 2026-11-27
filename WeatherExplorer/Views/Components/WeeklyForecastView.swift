//
//  WeeklyForecastView.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Neeche wali 7-day strip.
struct WeeklyForecastView: View {
    let days: [DailyForecast]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("7-Day Forecast", systemImage: "calendar")
                .font(.headline)

            HStack {
                ForEach(days) { day in
                    VStack(spacing: 8) {
                        Text(day.date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption)
                        Image(systemName: day.condition.symbolName)
                            .symbolRenderingMode(.multicolor)
                            .font(.title3)
                        Text("\(Int(day.tempMax.rounded()))°/\(Int(day.tempMin.rounded()))°")
                            .font(.caption2.bold())
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
    }
}
