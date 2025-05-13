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

    private let service = CountryService()
    private var cancellables = Set<AnyCancellable>()

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
                self?.countries = countries.sorted { $0.name.common < $1.name.common }
            })
            .store(in: &cancellables)
    }
}

