//
//  CurrentWeather.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Abhi ka mausam (screen ke top wala bada section).
struct CurrentWeather {
    let temperature: Double      // °C
    let feelsLike: Double
    let high: Double
    let low: Double
    let condition: WeatherCondition   // text + icon isi se aayenge
    var isDay: Bool = true   // NAYI: API ka is_day. Default true, isliye baaki code nahi tootega
}
