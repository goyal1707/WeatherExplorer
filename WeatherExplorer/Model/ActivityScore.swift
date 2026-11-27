//
//  ActivityScore.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Score ka level. Isse UI ka color decide hota hai.
enum ScoreLevel {
    case excellent   // 8+  -> green
    case good        // 5-8 -> yellow
    case poor        // <5  -> red
    case notApplicable
}

/// Ek din ka score (0...10) kisi ek activity ke liye.
struct DayScore: Identifiable {
    let date: Date
    let score: Double
    var id: Date { date }
}

/// Ek activity ka final result: 7 din ka average + din-wise scores.
struct ActivityScore: Identifiable {
    let activity: ActivityType
    /// 7-din ka average, 0...10. `nil` = is location par ye activity possible nahi / data nahi.
    let score: Double?
    /// Choti line: "Excellent conditions. Best day: Sat."
    let summary: String
    /// Din-wise scores (abhi UI mein nahi dikhte, par future drill-down ke liye ready).
    var dailyScores: [DayScore] = []

    var id: String { activity.id }

    var level: ScoreLevel {
        guard let score else { return .notApplicable }
        switch score {
        case 8...: return .excellent
        case 5..<8: return .good
        default: return .poor
        }
    }
}
