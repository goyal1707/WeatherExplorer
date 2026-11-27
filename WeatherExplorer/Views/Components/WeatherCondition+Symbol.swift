//
//  WeatherCondition+Symbol.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Icon UI ki cheez hai, isliye Model mein nahi, yahan (ScoreLevel+Color jaisa).
extension WeatherCondition {
    var symbolName: String {
        switch self {
        case .clear: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .fog: return "cloud.fog.fill"
        case .drizzle: return "cloud.drizzle.fill"
        case .rain: return "cloud.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .unknown: return "questionmark.circle"
        }
    }
}
