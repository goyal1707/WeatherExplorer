//
//  SwiftUIView.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import SwiftUI

/// Top wala search bar. Text ViewModel ke paas hai, ye sirf Binding se use badalta hai.
struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
            TextField("Search city or town...", text: $text)
                .autocorrectionDisabled()
                .submitLabel(.search)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
