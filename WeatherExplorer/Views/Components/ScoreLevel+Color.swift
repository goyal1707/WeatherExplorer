//
//  ScoreLevel+Color.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Color UI ki cheez hai, isliye Model mein nahi, Views mein rakha.
extension ScoreLevel {
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .orange
        case .poor: return .red
        case .notApplicable: return .gray
        }
    }
}
