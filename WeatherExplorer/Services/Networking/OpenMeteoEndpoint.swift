//
//  OpenMeteoEndpoint.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Saare URLs yahin banenge. Kahin aur hardcoded URL string nahi.
enum OpenMeteoEndpoint {

    /// https://geocoding-api.open-meteo.com/v1/search?name=Manali&count=10&language=en&format=json
    static func geocoding(query: String, count: Int = 10) -> URL? {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
        components?.queryItems = [
            URLQueryItem(name: "name", value: query),   // spaces/special chars apne aap encode honge
            URLQueryItem(name: "count", value: String(count)),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]
        return components?.url
    }

    /// https://api.open-meteo.com/v1/forecast?latitude=..&longitude=..&current=..&daily=..
    static func forecast(latitude: Double, longitude: Double) -> URL? {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: [
                "temperature_2m", "relative_humidity_2m", "apparent_temperature", "is_day",
                "precipitation", "rain", "snowfall", "weather_code", "wind_speed_10m"
            ].joined(separator: ",")),
            URLQueryItem(name: "daily", value: [
                "weather_code", "temperature_2m_max", "temperature_2m_min",
                "precipitation_probability_max", "precipitation_sum", "snowfall_sum",
                "wind_speed_10m_max", "sunrise", "sunset"
            ].joined(separator: ",")),
            URLQueryItem(name: "forecast_days", value: "7"),
            URLQueryItem(name: "timezone", value: "auto"),   // dates city ke local time mein aayengi
            URLQueryItem(name: "hourly", value: "snow_depth")
        ]
        return components?.url
    }
}
