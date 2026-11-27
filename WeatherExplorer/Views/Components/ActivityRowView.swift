//
//  ActivityRowView.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Card ke andar ek activity ki row: icon, naam, summary, progress bar, score badge.
struct ActivityRowView: View {
    let item: ActivityScore

    var body: some View {
        HStack(spacing: 12) {
            // TODO: SF Symbol ki jagah real photo (design match karne ke liye)
            Image(systemName: item.activity.symbolName)
                .font(.title2)
                .frame(width: 64, height: 64)
                .background(item.level.color.opacity(0.2), in: RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.activity.title).font(.headline)
                Text(item.summary).font(.subheadline).foregroundStyle(.secondary)
                progressBar
            }

            // ActivityScore+Display.swift se: 7 -> "7 / 10", 9.2 -> "9.2 / 10", nil -> "N/A"
            Text(item.scoreText)
                .font(.subheadline.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(item.level.color.opacity(0.2), in: Capsule())
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.gray.opacity(0.2))
                Capsule()
                    .fill(item.level.color)
                    .frame(width: geo.size.width * CGFloat((item.score ?? 0) / 10))
            }
        }
        .frame(height: 8)
    }
}
