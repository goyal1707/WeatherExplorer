//
//  GeocodingResponse.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Geocoding API ka poora response.
struct GeocodingResponse: Decodable {
    /// OPTIONAL: koi match na mile to "results" key JSON mein hoti hi nahi.
    let results: [GeocodingResult]?
}

/// Ek search result. Jo fields humein chahiye wahi rakhe hain, baaki JSON ignore ho jayega.
struct GeocodingResult: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let elevation: Double?   // skiing ke liye kaam aayega
    let country: String?
    let admin1: String?      // state/region, e.g. "Himachal Pradesh"
}

/// API shape -> hamara City model. Mapping ek hi jagah rakhi hai.
extension City {
    init(from result: GeocodingResult) {
        self.init(id: result.id,
                  name: result.name,
                  region: result.admin1 ?? "",
                  country: result.country ?? "",
                  latitude: result.latitude,
                  longitude: result.longitude,
                  elevation: result.elevation)
    }
}
