//
//  CountryListViewModel.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 13/5/25.
//

import Foundation
import Combine

class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published private(set) var favoriteIDs: Set<String> = []

    private let service: CountryServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allCountries: [Country] = []
    
    var favoriteCountries: [Country] {
        countries.filter { isFavorite($0) }
    }

    init(service: CountryServiceProtocol = CountryService()) {
        self.service = service
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.filterCountries(with: query)
            }
            .store(in: &cancellables)

        FavoriteManager.shared.$favoriteIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                self?.favoriteIDs = ids
            }
            .store(in: &cancellables)
    }

    func fetchCountries() {
        isLoading = true
        errorMessage = nil

        service.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] countries in
                self?.allCountries = countries
                self?.countries = countries.sorted { $0.name.common < $1.name.common }
            })
            .store(in: &cancellables)
    }

    func toggleFavorite(for country: Country) {
        FavoriteManager.shared.toggleFavorite(cca3: country.cca3)
    }

    func isFavorite(_ country: Country) -> Bool {
        favoriteIDs.contains(country.cca3)
    }

    private func filterCountries(with query: String) {
        if query.isEmpty {
            countries = allCountries
        } else {
            countries = allCountries.filter {
                $0.name.common.lowercased().contains(query.lowercased()) ||
                $0.capital?.first?.lowercased().contains(query.lowercased()) == true
            }
        }
    }
}

