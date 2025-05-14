//
//  MockCountryService.swift
//  CountriesSwiftUITests
//
//  Created by Daniel Cano on 14/5/25.
//

import Foundation
import Combine
@testable import CountriesSwiftUI

class MockCountryService: CountryServiceProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        let sample: [Country] = [
            Country(name: .init(common: "Spain"), capital: ["Madrid"], flags: .init(png: "https://flagcdn.com/w320/es.png"), cca3: "ESP", region: "Europe", population: 47000000),
            Country(name: .init(common: "France"), capital: ["Paris"], flags: .init(png: "https://flagcdn.com/w320/fr.png"), cca3: "FRA", region: "Europe", population: 65000000)
        ]
        
        return Just(sample)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
