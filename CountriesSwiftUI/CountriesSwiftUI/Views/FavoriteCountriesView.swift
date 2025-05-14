//
//  FavoriteCountriesView.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 14/5/25.
//

import Foundation
import SwiftUI

struct FavoriteCountriesView: View {
    @ObservedObject var viewModel = CountryListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.favoriteCountries) { country in
                NavigationLink(destination: CountryDetailView(country: country)) {
                    HStack {
                        AsyncImage(url: URL(string: country.flags.png)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 40, height: 25)
                        .cornerRadius(4)

                        VStack(alignment: .leading) {
                            Text(country.name.common)
                                .font(.headline)
                            if let capital = country.capital?.first {
                                Text("Capital: \(capital)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.fetchCountries()
        }
    }
}
