//
//  CountryDetailView.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 13/5/25.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: country.flags.png)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 150, height: 100)
            .cornerRadius(8)

            Text(country.name.common)
                .font(.largeTitle)
                .bold()

            if let capital = country.capital?.first {
                Text("Capital: \(capital)")
            }

            Text("Continent: \(country.region)")
            Text("Population: \(country.population.formatted())")

            Spacer()
        }
        .padding()
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CountryDetailView(country: .init(name: .init(common: "Test"), capital: nil, flags: .init(png: ""), cca3: "PRB", region: "PRB", population: 0))
}
