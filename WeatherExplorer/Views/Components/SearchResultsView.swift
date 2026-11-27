//
//  SearchResultsView.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Search karne par city ki list. Tap karne par `onSelect` chalega.
struct SearchResultsView: View {
    let cities: [City]
    let onSelect: (City) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(cities) { city in
                Button {
                    onSelect(city)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(city.name).font(.headline)
                        Text(detail(for: city)).font(.subheadline).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())   // poori row tappable
                }
                .buttonStyle(.plain)

                if city.id != cities.last?.id { Divider() }
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    /// "Himachal Pradesh, India · 1950 m". Elevation se same naam wali cities alag dikhti hain.
    private func detail(for city: City) -> String {
        guard let elevation = city.elevation else { return city.subtitle }
        return "\(city.subtitle) · \(Int(elevation)) m"
    }
}
