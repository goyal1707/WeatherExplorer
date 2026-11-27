//
//  DashboardViewModel.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation
import Observation

/// Dashboard ki poori state + actions. View sirf isse padhti hai.
/// @MainActor = ye class main thread par chalegi, isliye UI state safely badal sakte hain.
@MainActor
@Observable
final class DashboardViewModel {

    // MARK: - State (View ye dekhti hai)
    var city: City = .sample                 // Assumption: launch par default city Manali
    var current: CurrentWeather?             // nil = abhi load nahi hua
    var forecast: [DailyForecast] = []
    var errorMessage: String?

    // TODO (Step 4): ActivityScoringEngine se real scores. Abhi dummy hain, isliye UI par galat dikh sakte hain.
    var scores: [ActivityScore] = []

    var searchText = ""
    var searchResults: [City] = []
    var noResultsFound = false

    // MARK: - Dependencies (protocol, taaki tests mein fake service de sakein)
    private let geocodingService: GeocodingServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let scoringEngine = ActivityScoringEngine()

    init(geocodingService: GeocodingServiceProtocol = GeocodingService(),
         weatherService: WeatherServiceProtocol = WeatherService()) {
        self.geocodingService = geocodingService
        self.weatherService = weatherService
    }

    // MARK: - Actions

    /// Current city ka weather laao.
    func loadWeather() async {
        errorMessage = nil
        do {
            let result = try await weatherService.fetchForecast(for: city)
            current = result.current
            forecast = result.daily
            scores = scoringEngine.rankedScores(
                forecast: result.daily,
                elevation: city.elevation ?? result.elevation    // geocoding nahi to forecast API wali
            )
        } catch is CancellationError {
            // View hat gayi ya task cancel hua. Error nahi hai.
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Search box ka text badalne par chalta hai (View ka .task(id:) isse debounce karta hai).
    func updateSearchResults() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard query.count >= 2 else {
            searchResults = []
            noResultsFound = false
            return
        }
        do {
            // Debounce: user 400ms ruke tabhi API call. Naya letter aaya to ye task cancel
            // ho jata hai aur sleep CancellationError throw karta hai.
            try await Task.sleep(for: .milliseconds(400))
            searchResults = try await geocodingService.searchCities(matching: query)
            noResultsFound = searchResults.isEmpty
        } catch is CancellationError {
            // purani search cancel hui. Ignore.
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// User ne list se city chuni.
    func select(_ newCity: City) async {
        city = newCity
        searchText = ""
        searchResults = []
        noResultsFound = false
        current = nil          // purani city ka data na dikhe
        forecast = []
        scores = []
        await loadWeather()
    }
}
