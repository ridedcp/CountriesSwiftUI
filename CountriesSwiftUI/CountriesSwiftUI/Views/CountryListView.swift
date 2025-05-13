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
            VStack {
                TextField("Search country or capital", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])

                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading countries...")
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
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
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Countries in the world")
        }
        .onAppear {
            viewModel.fetchCountries()
        }
    }
}

#Preview {
    CountryListView()
}
