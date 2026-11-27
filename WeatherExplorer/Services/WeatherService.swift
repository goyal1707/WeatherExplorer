//
//  WeatherService.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchForecast(for city: City) async throws -> WeatherForecast
}

struct WeatherService: WeatherServiceProtocol {
    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    func fetchForecast(for city: City) async throws -> WeatherForecast {
        guard let url = OpenMeteoEndpoint.forecast(latitude: city.latitude,
                                                   longitude: city.longitude) else {
            throw APIError.invalidURL
        }
        let dto = try await client.get(ForecastResponse.self, from: url)  // raw API shape
        return try WeatherForecast(from: dto)                             // -> domain model
    }
}
