//
//  CountryListView.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 13/5/25.
//

import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel = CountryListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading countries...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.countries) { country in
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
                }
            }
            .navigationTitle("Countries in the World")
        }
        .onAppear {
            viewModel.fetchCountries()
        }
    }
}

#Preview {
    CountryListView()
}
