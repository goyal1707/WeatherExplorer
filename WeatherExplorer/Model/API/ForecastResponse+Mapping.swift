//
//  ForecastResponse+Mapping.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// API ka raw shape (ForecastResponse) -> hamare domain models. Mapping sirf yahin.
extension WeatherForecast {
    init(from dto: ForecastResponse) throws {
        let d = dto.daily

        // Saare arrays ki length barabar honi chahiye, warna data bharosemand nahi.
        guard !d.time.isEmpty,
              d.weatherCode.count == d.time.count,
              d.temperatureMax.count == d.time.count,
              d.temperatureMin.count == d.time.count else {
            throw APIError.invalidData
        }

        // "2026-11-27" -> Date. Device ke timezone mein parse aur format dono honge,
        // isliye "Mon/Tue" label hamesha sahi aayega.
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        // Optional arrays ke liye safe reader. null ya missing -> 0.
        // TODO: null ko 0 maanna ideal nahi (scoring mein "data nahi hai" alag cheez hai). Step 4 mein sochenge.
        func value(_ array: [Double?], _ index: Int) -> Double {
            array.indices.contains(index) ? (array[index] ?? 0) : 0
        }
        
        // Hourly snow_depth -> har din ka MAX.
         // "2026-11-27T13:00" ke pehle 10 characters = "2026-11-27", jo daily ki date se match karte hain.
         var snowDepthByDay: [String: Double] = [:]
        if let hourly = dto.hourly {
            for (time, depth) in zip(hourly.time, hourly.snowDepth) {
                guard let depth else { continue }   // null hour skip
                let day = String(time.prefix(10))
                snowDepthByDay[day] = max(snowDepthByDay[day] ?? 0, depth)
            }
        }

        var days: [DailyForecast] = []
        for (i, dateString) in d.time.enumerated() {
            guard let date = formatter.date(from: dateString) else { throw APIError.invalidData }
            days.append(DailyForecast(
                 date: date,
                 tempMax: d.temperatureMax[i],
                 tempMin: d.temperatureMin[i],
                 condition: WeatherCondition(wmoCode: d.weatherCode[i]),
                 precipitationProbability: value(d.precipitationProbabilityMax, i),
                 precipitationSum: value(d.precipitationSum, i),
                 snowfallSum: value(d.snowfallSum, i),
                 windSpeedMax: value(d.windSpeedMax, i),
                 snowDepthMax: snowDepthByDay[dateString]
             ))
        }

        let c = dto.current
        self.current = CurrentWeather(
             temperature: c.temperature,
             feelsLike: c.apparentTemperature,
             high: days[0].tempMax,      // aaj ka max/min = daily ka index 0
             low: days[0].tempMin,
             condition: WeatherCondition(wmoCode: c.weatherCode),
             isDay: c.isDay == 1         // API: 1 = din, 0 = raat
         )
        self.daily = days
        self.elevation = dto.elevation
    }
}
