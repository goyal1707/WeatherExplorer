//
//  ForecastResponse.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Forecast API ka response.
/// CodingKeys = JSON ke naam (temperature_2m) ko hamare saaf naam (temperature) se jodta hai.
struct ForecastResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let elevation: Double?
    let current: Current
    let daily: Daily
    let hourly: Hourly?

    /// Hourly: 7 din x 24 = 168 values. Hum sirf snow_depth lete hain.
    struct Hourly: Decodable {
        let time: [String]          // "2026-11-27T13:00" (city ke local time mein)
        let snowDepth: [Double?]    // METERS mein, null ho sakta hai

        enum CodingKeys: String, CodingKey {
            case time
            case snowDepth = "snow_depth"
        }
    }

    struct Current: Decodable {
        let temperature: Double
        let apparentTemperature: Double
        let relativeHumidity: Double
        let isDay: Int                 // 1 = din, 0 = raat
        let precipitation: Double
        let rain: Double
        let snowfall: Double
        let weatherCode: Int           // WMO code (0 = clear, 71 = snow...)
        let windSpeed: Double

        enum CodingKeys: String, CodingKey {
            case temperature = "temperature_2m"
            case apparentTemperature = "apparent_temperature"
            case relativeHumidity = "relative_humidity_2m"
            case isDay = "is_day"
            case precipitation, rain, snowfall
            case weatherCode = "weather_code"
            case windSpeed = "wind_speed_10m"
        }
    }

    /// Daily mein har cheez ek ARRAY hai, 7 din = 7 values. Index 0 = aaj.
    struct Daily: Decodable {
        let time: [String]                          // "2026-11-27"
        let weatherCode: [Int]
        let temperatureMax: [Double]
        let temperatureMin: [Double]
        // Neeche wale arrays mein API kabhi null bhej sakti hai, isliye [Double?]
        let precipitationProbabilityMax: [Double?]
        let precipitationSum: [Double?]
        let snowfallSum: [Double?]
        let windSpeedMax: [Double?]
        let sunrise: [String]
        let sunset: [String]

        enum CodingKeys: String, CodingKey {
            case time
            case weatherCode = "weather_code"
            case temperatureMax = "temperature_2m_max"
            case temperatureMin = "temperature_2m_min"
            case precipitationProbabilityMax = "precipitation_probability_max"
            case precipitationSum = "precipitation_sum"
            case snowfallSum = "snowfall_sum"
            case windSpeedMax = "wind_speed_10m_max"
            case sunrise, sunset
        }
    }
}
