//
//  City.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Ek city/town. Geocoding API ka result isi mein map hota hai.
struct City: Identifiable, Hashable {
    let id: Int
    let name: String        // "Manali"
    let region: String      // "Himachal Pradesh" (kabhi khali bhi ho sakta hai)
    let country: String     // "India"
    let latitude: Double
    let longitude: Double
    /// meters mein. Default nil, isliye SampleData.swift ko badalna nahi padega.
    var elevation: Double? = nil

    /// "Himachal Pradesh, India". Region khali ho to sirf country.
    var subtitle: String {
        [region, country].filter { !$0.isEmpty }.joined(separator: ", ")
    }
}
