//
//  GeocodingService.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// ViewModel is protocol se baat karega, concrete class se nahi (testing ke liye).
protocol GeocodingServiceProtocol {
    func searchCities(matching query: String) async throws -> [City]
}

struct GeocodingService: GeocodingServiceProtocol {
    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    func searchCities(matching query: String) async throws -> [City] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        // Open-Meteo ko kam se kam 2 characters chahiye. Faltu API call nahi karenge.
        guard trimmed.count >= 2 else { return [] }

        guard let url = OpenMeteoEndpoint.geocoding(query: trimmed) else {
            throw APIError.invalidURL
        }
        let response = try await client.get(GeocodingResponse.self, from: url)
        return (response.results ?? []).map(City.init(from:))
    }
}
