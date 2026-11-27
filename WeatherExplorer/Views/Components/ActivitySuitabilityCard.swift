//
//  ActivitySuitabilityCard.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Poora "Activity Suitability" card (title + 4 rows).
struct ActivitySuitabilityCard: View {
    let scores: [ActivityScore]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Activity Suitability", systemImage: "chart.bar.fill")
                    .font(.title3.bold())
                Spacer()
                // TODO - need perfect analysis (3): "Next 7 Days" dropdown ka matlab?
                // Options: (a) aaj ka din vs poora hafta, (b) din chun kar uska score,
                // (c) 7 din ka average. Abhi static label hai. Assumption README mein likhenge.
                Text("Next 7 days")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ForEach(scores) { item in
                ActivityRowView(item: item)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
    }
}
