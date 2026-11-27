//
//  DashboardView.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Poori screen. Decide karti hai kya dikhana hai: search results / loading / error / weather.
struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    /// Din: pehle jaisa blue (koi change nahi). Raat: dark navy.
    /// is_day API se aata hai aur us CITY ke local time ke hisaab se hota hai, phone ke time se nahi.
    private var backgroundColors: [Color] {
        let isDay = viewModel.current?.isDay ?? true    // data aane tak (spinner) din wala blue
        return isDay
            ? [Color.blue.opacity(0.85), Color.cyan.opacity(0.35)]
            : [Color(red: 0.04, green: 0.07, blue: 0.20), Color(red: 0.15, green: 0.20, blue: 0.40)]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: backgroundColors,
                            startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    SearchBarView(text: $viewModel.searchText)

                    if !viewModel.searchResults.isEmpty {
                        SearchResultsView(cities: viewModel.searchResults) { city in
                            Task { await viewModel.select(city) }
                        }
                    } else if viewModel.noResultsFound {
                        Text("No cities found")
                            .foregroundStyle(.white)
                            .padding(.top, 40)
                    } else {
                        weatherContent
                    }
                }
                .padding()
            }
        }
        // Screen khulte hi default city ka weather
        .task { await viewModel.loadWeather() }
        // searchText badla -> purana task cancel, naya shuru (yehi debounce ka trick hai)
        .task(id: viewModel.searchText) { await viewModel.updateSearchResults() }
    }

    /// Error / loading / real data me se ek.
    @ViewBuilder
    private var weatherContent: some View {
        if let message = viewModel.errorMessage {
            ErrorBannerView(message: message) {
                Task { await viewModel.loadWeather() }
            }
        } else if let current = viewModel.current {
            WeatherHeaderView(city: viewModel.city, current: current)
            ActivitySuitabilityCard(scores: viewModel.scores)
            WeeklyForecastView(days: viewModel.forecast)
        } else {
            ProgressView()
                .tint(.white)
                .padding(.top, 60)
        }
    }
}

#Preview {
    DashboardView()
}
