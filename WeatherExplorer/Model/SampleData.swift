//
//  SampleData.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

// Dummy data. Ab sirf 2 cheezein bachi hain jo abhi use ho rahi hain:
// 1) City.sample          -> app launch par default city (Manali)
// 2) ActivityScore.samples -> jab tak Step 4 ka ScoringEngine nahi aata
// Step 4 ke baad ActivityScore.samples bhi hat jayega.

extension City {
    static let sample = City(id: 1, name: "Manali", region: "Himachal Pradesh",
                             country: "India", latitude: 32.2574, longitude: 77.17481)
}
