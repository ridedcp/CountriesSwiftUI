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
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.countries) { country in
                        HStack {
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

                            Spacer()

                            Button {
                                viewModel.toggleFavorite(for: country)
                            } label: {
                                Image(systemName: viewModel.isFavorite(country) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $viewModel.searchText, prompt: "Search country or capital")
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
