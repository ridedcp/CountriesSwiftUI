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
    @Published var allCountries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    private let service = CountryService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.filterCountries(with: query)
            }
            .store(in: &cancellables)
    }
    
    func fetchCountries() {
        isLoading = true
        errorMessage = nil

        service.fetchCountries()
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

