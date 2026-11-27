//
//  WeatherForecast.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

import Foundation

/// Ek city ka poora weather: abhi ka + 7 din.
struct WeatherForecast {
    let current: CurrentWeather
    let daily: [DailyForecast]
    /// meters. Forecast API khud batati hai, isliye skiing ke liye city.elevation na ho tab bhi kaam chalega.
    let elevation: Double?
}
