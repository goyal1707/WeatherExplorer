//
//  ActivityScore+Display.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

extension ActivityScore {
    /// Whole number ho to decimal nahi: 9 -> "9 / 10", 0 -> "0 / 10". Warna 9.2 -> "9.2 / 10".
    /// nil -> "N/A". Alag extension mein hai taaki test ho sake.
    var scoreText: String {
        guard let score else { return "N/A" }
        let rounded = (score * 10).rounded() / 10     // pehle 1 decimal tak round
        let number = rounded == rounded.rounded()
            ? String(Int(rounded))
            : String(format: "%.1f", rounded)
        return "\(number) / 10"
    }
}
