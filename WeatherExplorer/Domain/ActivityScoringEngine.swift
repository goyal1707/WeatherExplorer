//
//  ActivityScoringEngine.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Weather data -> activity scores. PURE logic: koi UI, koi network, koi state nahi.
/// Har score 0...10. Saare thresholds judgment calls hain, README mein documented.
struct ActivityScoringEngine {

    /// Bina wave data ke "Excellent surfing" bolna jhooth hoga, isliye estimate ka max yahi.
    private let surfingEstimateCap = 7.0
    /// Isse upar ki jagah ko inland maante hain (Forecast API mein coast ka flag nahi hota).
    private let coastalMaxElevation = 30.0   // meters

    // MARK: - Public API

    /// Chaaron activities, best se worst (N/A sabse neeche).
    func rankedScores(forecast: [DailyForecast], elevation: Double?) -> [ActivityScore] {
        ActivityType.allCases
            .map { activityScore($0, forecast: forecast, elevation: elevation) }
            .sorted {
                let a = $0.score ?? -1, b = $1.score ?? -1
                return a != b ? a > b : $0.activity.title < $1.activity.title
            }
    }

    /// Ek activity, ek din. `nil` = score nahi nikal sakte (e.g. inland par surfing).
    func dayScore(_ activity: ActivityType, day: DailyForecast, elevation: Double?) -> Double? {
        let raw: Double?
        switch activity {
        case .skiing:             raw = skiing(day)
        case .surfing:            raw = surfing(day, elevation: elevation)
        case .outdoorSightseeing: raw = outdoor(day)
        case .indoorSightseeing:  raw = indoor(day)
        }
        return raw.map { (min(max($0, 0), 10) * 10).rounded() / 10 }   // 0...10, 1 decimal
    }

    // MARK: - Per-activity rules

    /// SKIING: barf nahi to skiing nahi. snowBase GATE hai (multiply hota hai).
    private func skiing(_ d: DailyForecast) -> Double {
        let snowBase: Double
        if let depth = d.snowDepthMax {
            snowBase = ramp(depth, bad: 0.1, good: 0.6)        // 10cm = 0, 60cm+ = full
        } else {
            snowBase = ramp(d.snowfallSum, bad: 0, good: 15)   // fallback: depth data nahi mila
        }
        // 2°C tak ideal, 10°C par barf pighalti hai. -25°C se neeche bhi khatarnaak thand.
        let temp = min(ramp(d.tempMax, bad: 10, good: 2),
                       ramp(d.tempMin, bad: -25, good: -12))
        let wind = ramp(d.windSpeedMax, bad: 60, good: 25)     // 60+ km/h = lifts band
        let fresh = ramp(d.snowfallSum, bad: 0, good: 10)      // 10cm+ taaza snow = bonus
        return 10 * snowBase * temp * (0.6 + 0.2 * wind + 0.2 * fresh)
    }

    /// SURFING (ESTIMATE): wave height nahi hai, isliye wind ko proxy maante hain.
    /// Inland ya elevation unknown -> nil (N/A).
    private func surfing(_ d: DailyForecast, elevation: Double?) -> Double? {
        guard let elevation, elevation <= coastalMaxElevation else { return nil }
        // Trapezoid: <8 km/h flat (0), 20-35 ideal, 60+ blown out (0).
        let swell = min(ramp(d.windSpeedMax, bad: 8, good: 20),
                        ramp(d.windSpeedMax, bad: 60, good: 35))
        let temp = ramp(d.tempMax, bad: 12, good: 22)
        let dry = ramp(d.precipitationSum, bad: 15, good: 2)
        // TODO: wind direction (offshore vs onshore) nahi dekh rahe, sirf speed.
        let quality = swell * (0.5 + 0.5 * temp) * (0.8 + 0.2 * dry) * conditionFactor(d.condition)
        return surfingEstimateCap * quality
    }

    /// OUTDOOR SIGHTSEEING: comfortable temp + dry + calm.
    private func outdoor(_ d: DailyForecast) -> Double {
        let temp = min(ramp(d.tempMax, bad: 0, good: 15), ramp(d.tempMax, bad: 38, good: 25))
        let dry = 0.5 * ramp(d.precipitationProbability, bad: 100, good: 0)
                + 0.5 * ramp(d.precipitationSum, bad: 10, good: 0)
        let wind = ramp(d.windSpeedMax, bad: 60, good: 25)
        return 10 * (0.35 * temp + 0.40 * dry + 0.25 * wind) * conditionFactor(d.condition)
    }

    /// INDOOR SIGHTSEEING: baseline 6, outdoor kharab ho to 10 tak.
    private func indoor(_ d: DailyForecast) -> Double {
        6 + 0.4 * (10 - outdoor(d))
    }

    // MARK: - Helpers

    /// `bad` par 0, `good` par 1, beech mein linear, bahar clamp. bad > good ho to bhi chalta hai.
    private func ramp(_ x: Double, bad: Double, good: Double) -> Double {
        min(max((x - bad) / (good - bad), 0), 1)
    }

    private func conditionFactor(_ c: WeatherCondition) -> Double {
        switch c {
        case .thunderstorm: return 0.2
        case .snow:         return 0.6
        case .fog:          return 0.7
        default:            return 1
        }
    }

    // MARK: - 7-day aggregation

    private func activityScore(_ activity: ActivityType,
                               forecast: [DailyForecast],
                               elevation: Double?) -> ActivityScore {
        let days: [DayScore] = forecast.compactMap { day in
            dayScore(activity, day: day, elevation: elevation)
                .map { DayScore(date: day.date, score: $0) }
        }

        guard let best = days.max(by: { $0.score < $1.score }) else {
            let reason = activity == .surfing ? "Not a coastal location." : "Not available."
            return ActivityScore(activity: activity, score: nil, summary: reason)
        }

        let average = days.map(\.score).reduce(0, +) / Double(days.count)
        let rounded = (average * 10).rounded() / 10
        return ActivityScore(activity: activity,
                             score: rounded,
                             summary: summary(for: activity, average: rounded, best: best),
                             dailyScores: days)
    }

    private func summary(for activity: ActivityType, average: Double, best: DayScore) -> String {
        if activity == .skiing && average < 0.5 { return "No snow or too warm to ski." }

        let phrase: String
        switch average {
        case 8...:  phrase = "Excellent conditions"
        case 5..<8: phrase = "Decent conditions"
        default:    phrase = "Poor conditions"
        }
        let estimate = activity == .surfing ? " (est.)" : ""

        guard best.score >= 5 else { return phrase + estimate + "." }
        let day = best.date.formatted(.dateTime.weekday(.abbreviated))
        return "\(phrase)\(estimate). Best day: \(day)."
    }
}
