//
//  ActivityType.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Assignment ki 4 activities. enum isliye ki list fixed hai.
/// CaseIterable = `ActivityType.allCases` se saari activities mil jaati hain.
enum ActivityType: String, CaseIterable, Identifiable {
    case skiing
    case surfing
    case outdoorSightseeing
    case indoorSightseeing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .skiing: return "Skiing"
        case .surfing: return "Surfing"
        case .outdoorSightseeing: return "Outdoor Sightseeing"
        case .indoorSightseeing: return "Indoor Sightseeing"
        }
    }

    /// SF Symbol (Apple ke built-in icons).
    /// TODO: mockup mein photos hain. Baad mein Assets.xcassets mein images daalkar yahan replace karenge.
    var symbolName: String {
        switch self {
        case .skiing: return "figure.skiing.downhill"
        case .surfing: return "figure.surfing"
        case .outdoorSightseeing: return "mountain.2.fill"
        case .indoorSightseeing: return "building.columns.fill"
        }
    }
}
