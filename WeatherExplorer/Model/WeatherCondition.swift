//
//  WeatherCondition.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// API ka WMO weather code (0, 61, 71...) hamare saaf enum mein.
/// Poori app mein sirf ye enum chalega, "magic numbers" kahin nahi.
enum WeatherCondition: Equatable {
    case clear, partlyCloudy, cloudy, fog, drizzle, rain, snow, thunderstorm, unknown

    init(wmoCode: Int) {
        switch wmoCode {
        case 0, 1:                             self = .clear
        case 2:                                self = .partlyCloudy
        case 3:                                self = .cloudy
        case 45, 48:                           self = .fog
        case 51, 53, 55, 56, 57:               self = .drizzle
        case 61, 63, 65, 66, 67, 80, 81, 82:   self = .rain
        case 71, 73, 75, 77, 85, 86:           self = .snow
        case 95, 96, 99:                       self = .thunderstorm
        default:                               self = .unknown
        }
    }

    // TODO: raat mein "Clear" hi theek hai, par din mein mockup jaisa "Sunny" dikhane ke liye isDay chahiye.
    var title: String {
        switch self {
        case .clear: return "Clear"
        case .partlyCloudy: return "Partly cloudy"
        case .cloudy: return "Cloudy"
        case .fog: return "Foggy"
        case .drizzle: return "Drizzle"
        case .rain: return "Rain"
        case .snow: return "Snow"
        case .thunderstorm: return "Thunderstorm"
        case .unknown: return "Unknown"
        }
    }
}
