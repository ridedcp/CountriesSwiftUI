//
//  CountryService.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 13/5/25.
//

import Foundation
import Combine

class CountryService: CountryServiceProtocol {
    private let url = URL(string: "https://restcountries.com/v3.1/all")!

    func fetchCountries() -> AnyPublisher<[Country], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
