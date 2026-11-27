//
//  WeatherHeaderView.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// City ka naam + bada temperature + condition + H/L.
struct WeatherHeaderView: View {
    let city: City
    let current: CurrentWeather

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(city.name, systemImage: "mappin.circle.fill")
                .font(.title.bold())
            Text(city.subtitle)
                .font(.subheadline)

            // .rounded() isliye ki 17.9 -> 18 ho, 17 nahi (Int() sirf kaat deta hai)
            Text("\(Int(current.temperature.rounded()))°C")
                .font(.system(size: 80, weight: .semibold))

            Label(current.condition.title, systemImage: current.condition.symbolName)
                .symbolRenderingMode(.multicolor)
                .font(.title3)

            Text("H:\(Int(current.high.rounded()))°  L:\(Int(current.low.rounded()))°  |  Feels like \(Int(current.feelsLike.rounded()))°")
                .font(.subheadline)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
