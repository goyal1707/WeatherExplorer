//
//  DailyForecast.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// 7-day forecast ka ek din. Scoring engine (Step 4) ye saari values use karega.
struct DailyForecast: Identifiable {
    let date: Date
    let tempMax: Double                  // °C
    let tempMin: Double                  // °C
    let condition: WeatherCondition
    let precipitationProbability: Double // %
    let precipitationSum: Double         // mm
    let snowfallSum: Double              // cm
    let windSpeedMax: Double             // km/h
    var snowDepthMax: Double? = nil
    var id: Date { date }
}
